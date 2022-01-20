/*
 *
 *      Copyright (c) 2018-2099, lipengjun All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,
 *  this list of conditions and the following disclaimer.
 *  Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the distribution.
 *  Neither the name of the fly2you.cn developer nor the names of its
 *  contributors may be used to endorse or promote products derived from
 *  this software without specific prior written permission.
 *  Author: lipengjun (939961241@qq.com)
 *
 */
package com.platform.modules.mall.service;

import com.alibaba.fastjson.JSONObject;
import com.alipay.easysdk.factory.Factory;
import com.alipay.easysdk.payment.app.models.AlipayTradeAppPayResponse;
import com.alipay.easysdk.payment.common.models.AlipayTradeCreateResponse;
import com.alipay.easysdk.payment.common.models.AlipayTradeRefundResponse;
import com.alipay.easysdk.payment.page.models.AlipayTradePagePayResponse;
import com.alipay.easysdk.payment.wap.models.AlipayTradeWapPayResponse;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.github.binarywang.utils.qrcode.QrcodeUtils;
import com.github.binarywang.wxpay.bean.notify.WxPayNotifyResponse;
import com.github.binarywang.wxpay.bean.notify.WxPayOrderNotifyResult;
import com.github.binarywang.wxpay.bean.notify.WxPayRefundNotifyResult;
import com.github.binarywang.wxpay.bean.notify.WxScanPayNotifyResult;
import com.github.binarywang.wxpay.bean.order.WxPayAppOrderResult;
import com.github.binarywang.wxpay.bean.order.WxPayMpOrderResult;
import com.github.binarywang.wxpay.bean.order.WxPayMwebOrderResult;
import com.github.binarywang.wxpay.bean.request.BaseWxPayRequest;
import com.github.binarywang.wxpay.bean.request.WxPayRefundRequest;
import com.github.binarywang.wxpay.bean.request.WxPayUnifiedOrderRequest;
import com.github.binarywang.wxpay.bean.result.BaseWxPayResult;
import com.github.binarywang.wxpay.bean.result.WxPayRefundResult;
import com.github.binarywang.wxpay.bean.result.WxPayUnifiedOrderResult;
import com.github.binarywang.wxpay.exception.WxPayException;
import com.github.binarywang.wxpay.service.WxPayService;
import com.platform.common.exception.BusinessException;
import com.platform.common.utils.*;
import com.platform.config.AliPayService;
import com.platform.modules.mall.entity.*;
import com.platform.modules.sys.entity.SysPrinterEntity;
import com.platform.modules.sys.service.SysConfigService;
import com.platform.modules.sys.service.SysPrinterService;
import com.thoughtworks.xstream.XStream;
import lombok.extern.slf4j.Slf4j;
import me.chanjar.weixin.common.util.xml.XStreamInitializer;
import org.apache.commons.lang.ObjectUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * @author 李鹏军
 */
@Slf4j
@Service("payService")
public class PayService {
    @Autowired
    private WxPayService wxPayService;
    @Autowired
    private MallOrderService orderService;
    @Autowired
    private MallGoodsService goodsService;
    @Autowired
    private MallUserService userService;
    @Autowired
    private MallOrderGoodsService orderGoodsService;
    @Autowired
    private WxSendMsgService sendMsgService;
    @Autowired
    private MallAccountLogService accountLogService;
    @Autowired
    private MallDistOrderService mallDistOrderService;
    @Autowired
    private MallShopsService shopsService;
    @Autowired
    private SysPrinterService printerService;
    @Autowired
    private MallPayFaceToFaceService payFaceToFaceService;
    @Autowired
    private MallUserCouponService userCouponService;
    @Autowired
    private MallOrderRefundService orderRefundService;
    @Autowired
    private MallOrderSaleserviceService orderSaleserviceService;
    @Autowired
    private SysConfigService sysConfigService;
    @Autowired
    private AliPayService aliPayService;
    @Autowired
    private MallGroupBuyingRecordService buyingRecordService;
    @Autowired
    private MallIntegralLogService integralLogService;

    @Value("${wx.pay.baseNotifyUrl}")
    private String baseNotifyUrl;
    @Value("${wx.pay.spbillCreateIp}")
    private String spbillCreateIp;
    @Value("${qq.pay.mchId}")
    private String mchId;
    @Value("${qq.pay.mchKey}")
    private String mchKey;
    @Value("${qq.miniapp.appid}")
    private String appid;
    @Value("${wx.app.appId}")
    private String appAppId;

    /**
     * 退款
     *
     * @param orderVo
     * @param refundFee 退款金额，单位：元
     * @return
     */
    public RestResponse refund(MallOrderEntity orderVo, String refundFee) {
        if (orderVo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            String orderSn = orderVo.getOrderSn();
            // 退款支持单笔交易分多次退款，多次退款需要提交原支付订单的商户订单号和设置不同的退款单号
            String outRefundNo = orderVo.getOrderSn();
            boolean flag = false;

            BigDecimal actualPrice = orderVo.getActualPrice();
            // 如果是子订单，退款使用父级ID，支持多次申请退款
            if (StringUtils.isNotBlank(orderVo.getParentId()) && !"拼团订单".equals(orderVo.getParentId()) && !"秒杀订单".equals(orderVo.getParentId())) {
                outRefundNo = "TK" + StringUtils.generateOrderNumber();
                orderSn = orderVo.getParentId();
                // 原支付订单总金额
                actualPrice = orderService.getById(orderSn).getActualPrice();
            }

            //微信支付退款
            if (Constant.PayType.WX.getValue().equals(orderVo.getPayType())) {
                WxPayRefundRequest request = new WxPayRefundRequest();
                request.setOutRefundNo(outRefundNo);
                request.setOutTradeNo(orderSn);
                request.setTotalFee(BaseWxPayRequest.yuanToFen(actualPrice.toString()));
                request.setRefundFee(BaseWxPayRequest.yuanToFen(refundFee));
                request.setRefundDesc("用户取消订单");
                WxPayRefundResult result;
                try {
                    result = wxPayService.refundV2(request);
                } catch (WxPayException e) {
                    throw new BusinessException("退款失败：" + e.getErrCode());
                }
                if (result.getResultCode().equals(Constant.SUCCESS)) {
                    flag = true;
                }
            }

            // 支付宝支付退款
            if (Constant.PayType.ZFB.getValue().equals(orderVo.getPayType())) {
                AlipayTradeRefundResponse response;
                try {
                    response = aliPayService.refundTrade(orderSn, refundFee, outRefundNo);
                } catch (Exception e) {
                    throw new BusinessException("退款失败：" + e.getMessage());
                }
                if (response.getMsg().equalsIgnoreCase(Constant.SUCCESS)) {
                    flag = true;
                }
            }
            MallUserEntity mallUserEntity = userService.getById(orderVo.getUserId());
            // 余额支付
            if (Constant.PayType.YE.getValue().equals(orderVo.getPayType())) {
                MallAccountLogEntity accountLogEntity = new MallAccountLogEntity();
                accountLogEntity.setLogDesc("退款");
                accountLogEntity.setUserId(orderVo.getUserId());
                accountLogEntity.setFromType(orderVo.getFromType());
                accountLogEntity.setType(1);
                accountLogEntity.setAddTime(new Date());
                accountLogEntity.setOrderType(Constant.NORMAL_ORDER);
                accountLogEntity.setPrice(orderVo.getActualPrice());
                accountLogEntity.setOrderSn(StringUtils.generateOrderNumber());
                accountLogService.save(accountLogEntity);
                mallUserEntity.setBalance(mallUserEntity.getBalance().add(new BigDecimal(refundFee)));
                boolean success = userService.update(mallUserEntity);
                if (success) {
                    flag = true;
                }
            }
            if (flag) {
                if (orderVo.getOrderStatus().equals(Constant.OrderStatus.YFH.getValue())) {
                    orderVo.setOrderStatus(Constant.OrderStatus.THTK.getValue());
                } else {
                    orderVo.setOrderStatus(Constant.OrderStatus.TK.getValue());
                }
                orderVo.setPayStatus(Constant.PayStatus.TK.getValue());
                orderService.update(orderVo);

                //更新退款记录表
                MallOrderRefundEntity refund = orderRefundService.getByOrderSn(orderSn);
                if (null != refund) {
                    refund.setRefundStatus(2);
                    refund.setRefundTime(new Date());
                    orderRefundService.update(refund);
                }
                MallOrderSaleserviceEntity saleService = orderSaleserviceService.getByOrderSn(orderSn);
                if (null != saleService) {
                    saleService.setStatus(3);
                    saleService.setRefundTime(new Date());
                    orderSaleserviceService.update(saleService);
                } else {
                    saleService = new MallOrderSaleserviceEntity();
                    saleService.setOrderSn(orderSn);
                    saleService.setUserId(orderVo.getUserId());
                    saleService.setSaleserviceSn("TK" + StringUtils.generateOrderNumber());
                    saleService.setReason("用户取消订单自动退款");
                    saleService.setAmount(new BigDecimal(refundFee));
                    saleService.setStatus(3);
                    saleService.setCreateTime(new Date());
                    saleService.setHandleTime(new Date());
                    saleService.setRefundTime(new Date());
                    saleService.setHandleReason("自动退款");
                    orderSaleserviceService.save(saleService);
                }

                //取消订单释放商品库存
                goodsService.backGoodsNumber(orderVo);
                //退回优惠券
                if (StringUtils.isNotBlank(orderVo.getCouponId())) {
                    userCouponService.backCoupon(orderVo.getId());
                }
                Integer totaRefundlFee = Integer.parseInt(refundFee.split("\\.")[0]);
                // 退款减去购物积分
                // 退款减去购物积分，只有微信、支付宝支付才增加积分
                if (Constant.PayType.WX.getValue().equals(orderVo.getPayType()) || Constant.PayType.ZFB.getValue().equals(orderVo.getPayType())) {
                    // 扣除积分后小于0，设置为0
                    if (mallUserEntity.getIntegral() < totaRefundlFee) {
                        mallUserEntity.setIntegral(0);
                    } else {
                        mallUserEntity.setIntegral(mallUserEntity.getIntegral() - totaRefundlFee);
                    }
                    userService.update(mallUserEntity);
                }
                return RestResponse.success("取消成功！");
            } else {
                return RestResponse.error("取消失败！");
            }
        } else {
            orderVo.setOrderStatus(Constant.OrderStatus.YQX.getValue());
            orderService.update(orderVo);
            //取消订单释放商品库存
            goodsService.backGoodsNumber(orderVo);
            //退回优惠券
            if (StringUtils.isNotBlank(orderVo.getCouponId())) {
                userCouponService.backCoupon(orderVo.getId());
            }
            return RestResponse.success("取消成功！");
        }
    }

    /**
     * 当面付
     *
     * @param loginUser
     * @param jsonParam
     * @return
     */
    public RestResponse faceToface(MallUserEntity loginUser, JSONObject jsonParam) {
        String tradeType = jsonParam.getString("tradeType");
        String money = jsonParam.getString("money");
        String shopsId = jsonParam.getString("shopsId");
        Integer fromType = jsonParam.getInteger("fromType");
        String mpAppId = jsonParam.getString("mpAppId");
        String orderSn = StringUtils.generateOrderNumber();

        MallPayFaceToFaceEntity faceToFaceEntity = new MallPayFaceToFaceEntity();
        faceToFaceEntity.setUserId(loginUser.getId());
        faceToFaceEntity.setFromType(fromType);
        faceToFaceEntity.setOrderSn(orderSn);
        faceToFaceEntity.setPayStatus(Constant.PayStatus.WFK.getValue());
        faceToFaceEntity.setActualPrice(new BigDecimal(money));
        faceToFaceEntity.setAddTime(new Date());
        faceToFaceEntity.setShopsId(shopsId);
        try {
            WxPayMpOrderResult data = null;
            WxPayMwebOrderResult mwebOrderResult = null;
            WxPayAppOrderResult appOrderResult = null;
            if (ObjectUtils.equals(tradeType, "JSAPI") || ObjectUtils.equals(tradeType, "APP")
                    || ObjectUtils.equals(tradeType, "MWEB")) {

                //调用统一下单接口，并组装生成支付所需参数对象
                WxPayUnifiedOrderRequest request = new WxPayUnifiedOrderRequest();
                request.setBody("当面付用户：" + loginUser.getNickname());
                request.setOutTradeNo(orderSn);
                //支付金额
                request.setTotalFee(BaseWxPayRequest.yuanToFen(money));
                request.setSpbillCreateIp(spbillCreateIp);
                // 回调地址
                request.setNotifyUrl(baseNotifyUrl + "/app/pay/faceToFaceNotify");
                // 交易类型APP
                request.setTradeType(tradeType);
                if (ObjectUtils.equals(tradeType, "MWEB")) {
                    //微信H5支付
                    mwebOrderResult = wxPayService.createOrder(request);
                } else if (ObjectUtils.equals(tradeType, "APP")) {
                    //APP支付
                    request.setAppid(appAppId);
                    appOrderResult = wxPayService.createOrder(request);
                } else {
                    //小程序、公众号支付
                    if (fromType.equals(Constant.FromType.MP.getValue())) {
                        // 改为从前端传入
                        request.setAppid(mpAppId);
                        request.setOpenid(loginUser.getMpOpenId());
                    }
                    if (fromType.equals(Constant.FromType.MA.getValue())) {
                        request.setOpenid(loginUser.getOpenId());
                    }
                    data = wxPayService.createOrder(request);
                }
            }
            payFaceToFaceService.save(faceToFaceEntity);
            return RestResponse.success().put("data", data).put("mwebOrderResult", mwebOrderResult).put("appOrderResult", appOrderResult);
        } catch (WxPayException e) {
            e.printStackTrace();
            return RestResponse.error("下单失败,error=" + e.getErrCodeDes());
        }
    }

    /**
     * 当面付回调接口
     *
     * @param xmlData
     * @return
     */
    public String faceToFaceNotify(String xmlData) {
        try {
            WxPayOrderNotifyResult result = wxPayService.parseOrderNotifyResult(xmlData);
            String resultCode = result.getResultCode();
            String outTradeNo = result.getOutTradeNo();
            if (resultCode.equalsIgnoreCase(Constant.FAIL)) {
                //订单编号
                log.error("订单" + outTradeNo + "支付失败");
                return setXml(Constant.SUCCESS, "OK");
            } else if (resultCode.equalsIgnoreCase(Constant.SUCCESS)) {
                //订单编号
                log.error("订单" + outTradeNo + "支付成功");
                // 业务处理
                MallPayFaceToFaceEntity payFaceToFaceEntity = payFaceToFaceService.getOne(new QueryWrapper<MallPayFaceToFaceEntity>().eq("ORDER_SN", outTradeNo));
                // 已经支付,不再执行
                if (payFaceToFaceEntity.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
                    return setXml(Constant.SUCCESS, "OK");
                }
                payFaceToFaceEntity.setPayStatus(Constant.PayStatus.YFK.getValue());
                payFaceToFaceEntity.setPayTime(new Date());

                MallShopsEntity shopsEntity = shopsService.getById(payFaceToFaceEntity.getShopsId());
                MallUserEntity userEntity = userService.getById(payFaceToFaceEntity.getUserId());

                StringBuilder content = new StringBuilder("<CB>微同商城</CB><BR>");
                content.append("当面付：").append(payFaceToFaceEntity.getOrderSn()).append("<BR>");
                content.append("门店名称：【").append(shopsEntity.getName()).append("】<BR>");
                content.append("--------------------------------<BR>");
                content.append("会员昵称：").append(userEntity.getNickname()).append("<BR>");
                content.append("付款金额：").append(payFaceToFaceEntity.getActualPrice()).append("<BR>");
                content.append("付款时间：").append(DateUtils.format(payFaceToFaceEntity.getPayTime(), DateUtils.DATE_TIME_PATTERN)).append("<BR>");
                // 二维码是订单编号
                content.append("<QR>").append(payFaceToFaceEntity.getOrderSn()).append("</QR>");

                //获取门店的打印机编号，每个门店只有一个打票机
                SysPrinterEntity printerEntity = printerService.getOne(new QueryWrapper<SysPrinterEntity>().eq("SHOPS_ID", payFaceToFaceEntity.getShopsId()), false);
                if (null != printerEntity) {
                    // 第一次打印
                    PrintUtils.printMsg(printerEntity.getSn(), content.toString(), "1");
                    content.append("<RIGHT><BOLD>【存根】</BOLD></RIGHT>");
                    content.append("<CUT>");

                    // 第二次存根打印
                    PrintUtils.printMsg(StringUtils.isNotBlank(printerEntity.getStubSn()) ? printerEntity.getStubSn() : printerEntity.getSn(), content.toString(), "1");
                }
                payFaceToFaceService.update(payFaceToFaceEntity);

                // 支付成功、 订单总金额(单位：分) 除以100保留两位小数
                BigDecimal totalFee = new BigDecimal(result.getTotalFee()).divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP);
                // 增加购物积分 消费金额与购物积分1：1增加
                userEntity.setIntegral(userEntity.getIntegral() + totalFee.intValue());
                userService.update(userEntity);
            } else {
                log.error("订单处理异常");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return setXml(Constant.SUCCESS, "OK");
    }

    /**
     * 商品统一下单请求
     *
     * @param loginUser
     * @param jsonParam
     * @return
     */
    public RestResponse payPrepay(MallUserEntity loginUser, JSONObject jsonParam) {
        String orderId = jsonParam.getString("orderId");
        String tradeType = jsonParam.getString("tradeType");
        String mpAppId = jsonParam.getString("mpAppId");

        MallOrderEntity orderInfo = orderService.getById(orderId);
        if (null == orderInfo) {
            return RestResponse.error("订单已取消！");
        }
        if (!loginUser.getId().equals(orderInfo.getUserId())) {
            return RestResponse.error("非法操作！");
        }
        if (orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            return RestResponse.error("订单已支付，请不要重复操作！");
        }

        Map<String, Object> orderGoodsParam = new HashMap<>(2);
        orderGoodsParam.put("orderId", orderId);
        //订单的商品
        List<MallOrderGoodsEntity> orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        if (null == orderGoods || orderGoods.size() == 0) {
            // 父级订单下的子订单商品
            orderGoodsParam = new HashMap<>(2);
            orderGoodsParam.put("parentId", orderId);
            orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        }
        StringBuilder body = new StringBuilder();
        if (null != orderGoods && orderGoods.size() > 0) {
            for (MallOrderGoodsEntity goodsVo : orderGoods) {
                if (body.toString().getBytes(StandardCharsets.UTF_8).length < 90) {
                    body.append(goodsVo.getGoodsName()).append("*").append(goodsVo.getNumber()).append("、");
                } else {
                    body.append("...");
                }
            }
            if (body.length() > 0) {
                body = new StringBuilder(body.substring(0, body.length() - 1));
            }
        }
        try {
            WxPayMpOrderResult data = null;
            WxPayMwebOrderResult mwebOrderResult = null;
            WxPayAppOrderResult appOrderResult = null;
            //微信支付
            if (ObjectUtils.equals(tradeType, "JSAPI") || ObjectUtils.equals(tradeType, "APP")
                    || ObjectUtils.equals(tradeType, "MWEB")) {

                //调用统一下单接口，并组装生成支付所需参数对象
                WxPayUnifiedOrderRequest request = new WxPayUnifiedOrderRequest();
                request.setBody(body.toString());
                request.setOutTradeNo(orderInfo.getOrderSn());
                //支付金额
                request.setTotalFee(BaseWxPayRequest.yuanToFen(orderInfo.getActualPrice().toString()));
                request.setSpbillCreateIp(spbillCreateIp);
                // 回调地址
                request.setNotifyUrl(baseNotifyUrl + "/app/pay/notify");
                // 交易类型APP
                request.setTradeType(tradeType);
                try {
                    if (ObjectUtils.equals(tradeType, "MWEB")) {
                        //微信H5支付
                        mwebOrderResult = wxPayService.createOrder(request);
                    } else if (ObjectUtils.equals(tradeType, "APP")) {
                        //APP支付
                        request.setAppid(appAppId);
                        appOrderResult = wxPayService.createOrder(request);
                    } else {
                        //小程序、公众号支付
                        if (orderInfo.getFromType().equals(Constant.FromType.MP.getValue())) {
                            request.setAppid(mpAppId);
                            request.setOpenid(loginUser.getMpOpenId());
                        }
                        if (orderInfo.getFromType().equals(Constant.FromType.MA.getValue())) {
                            request.setOpenid(loginUser.getOpenId());
                        }
                        data = wxPayService.createOrder(request);
                    }
                } catch (WxPayException e) {
                    /**
                     * 参考:微信支付出现OUT_TRADE_NO_USED:商户订单号重复
                     *
                     * 场景：使用微信支付，在微信支付界面，由于余额不足等原因，没有进行支付并关闭了支付页面，此时订单状态为“待支付”，从业务角度来说，应该允许用户继续支付。但是再次支付时，微信接口返回“201 商户订单号重复”的错误提示。
                     * 解决办法：待支付的订单号（即商户订单号，out_trade_no），再次支付时，务必保持商品描述字段和上次请求的内容完全一致。
                     * 　　　　另外，如果价格改变，也不能重复提交，只能重新生成订单号，重新向微信发起支付请求
                     * 这里如果客户下单后点击支付然后取消付款，在联系客服后台修改价格，用户再次下单就会产生此错误
                     * 这里处理方式是在订单号头部添加XG
                     */
                    if (e.getErrCodeDes() != null && e.getErrCodeDes().contains("商户订单号重复")) {
                        String orderSn = "XG" + orderInfo.getOrderSn();
                        orderInfo.setOrderSn(orderSn);
                        orderService.update(orderInfo);
                        request.setOutTradeNo(orderSn);

                        if (ObjectUtils.equals(tradeType, "MWEB")) {
                            mwebOrderResult = wxPayService.createOrder(request);
                        } else if (ObjectUtils.equals(tradeType, "APP")) {
                            appOrderResult = wxPayService.createOrder(request);
                        } else {
                            data = wxPayService.createOrder(request);
                        }
                    } else {
                        e.printStackTrace();
                        return RestResponse.error("下单失败,error=" + e.getReturnMsg());
                    }
                }
            }
            //QQ钱包支付
            if (ObjectUtils.equals(orderInfo.getFromType(), Constant.FromType.QQ.getValue())) {
                Map<Object, Object> request = new TreeMap<>();
                request.put("appid", appid);
                request.put("mch_id", mchId);
                // 商品描述
                request.put("body", body.toString());
                request.put("nonce_str", CharUtil.getRandomNum(18).toUpperCase());
                // 数字签证
                String sign = QqPayUtils.arraySign(request, mchKey);
                request.put("sign", sign);

                // 回调地址
                request.put("notify_url", baseNotifyUrl + "/app/pay/notify");
                request.put("out_trade_no", orderInfo.getOrderSn());
                request.put("spbill_create_ip", spbillCreateIp);
                //支付金额
                request.put("total_fee", BaseWxPayRequest.yuanToFen(orderInfo.getActualPrice().toString()));
                // 交易类型APP
                request.put("trade_type", tradeType);

                request.put("fee_type", "CNY");

                String xml = QqPayUtils.convertMap2Xml(request);
                String url = "https://qpay.qq.com/cgi-bin/pay/qpay_unified_order.cgi";

                String responseContent = wxPayService.post(url, xml, false);
                WxPayUnifiedOrderResult unifiedOrderResult = BaseWxPayResult.fromXML(responseContent, WxPayUnifiedOrderResult.class);

                //保存prepayId
                orderInfo.setPrepayId(unifiedOrderResult.getPrepayId());
                orderService.update(orderInfo);

                data = QqPayUtils.createOrder(unifiedOrderResult, request, mchKey);
            }

            // 添加分销订单
            if (orderInfo.getOrderType() == 1) {
                mallDistOrderService.addDistOrder(loginUser.getId(), orderInfo.getId());
            }

            return RestResponse.success().put("data", data).put("mwebOrderResult", mwebOrderResult).put("appOrderResult", appOrderResult);
        } catch (WxPayException e) {
            e.printStackTrace();
            return RestResponse.error("下单失败,error=" + e.getErrCodeDes());
        }
    }

    /**
     * 商品统一下单请求回调接口
     *
     * @param xmlData
     * @return
     */
    public String notify(String xmlData) {
        try {
            WxPayOrderNotifyResult result = wxPayService.parseOrderNotifyResult(xmlData);
            String resultCode = result.getResultCode();
            String outTradeNo = result.getOutTradeNo();
            if (resultCode.equalsIgnoreCase(Constant.FAIL)) {
                //订单编号
                log.error("订单" + outTradeNo + "支付失败");
                return setXml(Constant.SUCCESS, "OK");
            } else if (resultCode.equalsIgnoreCase(Constant.SUCCESS)) {
                return notifySuccess(outTradeNo, Constant.PayType.WX.getValue());
            } else {
                log.error("订单处理异常");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return setXml(Constant.SUCCESS, "OK");
    }

    /**
     * 余额支付（购买商品）
     *
     * @param loginUser
     * @param jsonParam
     * @return
     */
    public RestResponse buyByYue(MallUserEntity loginUser, JSONObject jsonParam) {
        String orderId = jsonParam.getString("orderId");
        Integer fromType = jsonParam.getInteger("fromType");

        MallOrderEntity orderInfo = orderService.getById(orderId);

        if (null == orderInfo) {
            return RestResponse.error("订单已取消！");
        }
        if (!loginUser.getId().equals(orderInfo.getUserId())) {
            return RestResponse.error("越权操作！");
        }

        if (orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            return RestResponse.error("订单已支付，请不要重复操作！");
        }
        MallUserEntity malluserentity = userService.getById(orderInfo.getUserId());
        // 用户余额不足
        if (malluserentity.getBalance() == null || malluserentity.getBalance().doubleValue() < orderInfo.getActualPrice().doubleValue()) {
            return RestResponse.error(300, "用户余额不足！");
        } else {
            MallAccountLogEntity accountLogEntity = new MallAccountLogEntity();
            accountLogEntity.setLogDesc("余额支付");
            accountLogEntity.setUserId(loginUser.getId());
            accountLogEntity.setFromType(fromType);
            accountLogEntity.setType(2);
            accountLogEntity.setAddTime(new Date());
            accountLogEntity.setOrderType(Constant.NORMAL_ORDER);
            accountLogEntity.setPrice(orderInfo.getActualPrice());
            accountLogEntity.setOrderSn(StringUtils.generateOrderNumber());
            accountLogService.save(accountLogEntity);

            malluserentity.setBalance(malluserentity.getBalance().subtract(orderInfo.getActualPrice()));
            userService.update(malluserentity);
            // 业务处理
            notifySuccess(orderInfo.getOrderSn(), Constant.PayType.YE.getValue());

            return RestResponse.success("支付成功！");
        }
    }

    // 支付成功回调业务处理
    private String notifySuccess(String outTradeNo, int payType) {
        //订单编号
        log.error("订单" + outTradeNo + "支付成功");
        // 业务处理
        List<MallOrderEntity> list = orderService.list(new QueryWrapper<MallOrderEntity>().eq("ORDER_SN", outTradeNo).or().eq("PARENT_ID", outTradeNo));
        list.forEach(orderInfo -> {
            // 已经支付,不再执行
            if (!orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
                orderInfo.setPayType(payType);
                orderInfo.setPayStatus(Constant.PayStatus.YFK.getValue());
                orderInfo.setPayTime(new Date());
                if (orderInfo.getOrderStatus().equals(Constant.OrderStatus.YQX.getValue()) || orderInfo.getOrderStatus().equals(Constant.OrderStatus.DFK.getValue())) {
                    orderInfo.setOrderStatus(Constant.OrderStatus.YFK.getValue());
                }
                if (orderInfo.getOrderStatus().equals(Constant.OrderStatus.DXD.getValue())) {
                    orderInfo.setOrderStatus(Constant.OrderStatus.YFK.getValue());
                }
                orderInfo.setShippingStatus(Constant.ShippingStatus.WFH.getValue());
                if (null == orderInfo.getCouponPrice()) {
                    orderInfo.setCouponPrice(new BigDecimal(0));
                }
                orderService.update(orderInfo);
                /**
                 * 门店打印
                 */
                MallShopsEntity shopsEntity = shopsService.getById(orderInfo.getShopsId());
                Map<String, Object> map = new HashMap<>();
                map.put("orderId", orderInfo.getId());
                List<MallOrderGoodsEntity> orderGoodsEntities = orderGoodsService.queryAll(map);
                StringBuilder content = new StringBuilder("<CB>微同商城</CB><BR>");
                content.append("订单：").append(orderInfo.getOrderSn()).append("<BR>");
                content.append("门店名称：【").append(shopsEntity.getName()).append("】<BR>");
                content.append("--------------------------------<BR>");
                content.append("商品名称  单价  数量  金额<BR>");
                for (MallOrderGoodsEntity orderGoodsEntity : orderGoodsEntities) {
                    content.append("--------------------------------<BR>");
                    content.append(orderGoodsEntity.getGoodsName()).append("  ")
                            .append(orderGoodsEntity.getRetailPrice()).append("  ").append(orderGoodsEntity.getNumber()).append("  ")
                            .append(orderGoodsEntity.getRetailPrice().multiply(new BigDecimal(orderGoodsEntity.getNumber()))).append("<BR>");
                }
                content.append("--------------------------------<BR>");
                content.append("备注：").append(orderInfo.getPostscript()).append("<BR>");
                content.append("--------------------------------<BR>");

                content.append("收件人：").append(orderInfo.getConsignee()).append("<BR>");
                content.append("联系电话：").append(orderInfo.getMobile()).append("<BR>");
                content.append("优惠价格：").append(orderInfo.getCouponPrice()).append("元<BR>");
                content.append("合计：").append(orderInfo.getOrderPrice()).append("元<BR>");
                content.append("实付：").append(orderInfo.getActualPrice()).append("元<BR>");
                String payTypeText = "微信支付";
                if (payType == 2) {
                    payTypeText = "微信支付";
                }
                if (payType == 3) {
                    payTypeText = "支付宝支付";
                }
                if (payType == 4) {
                    payTypeText = "积分兑换";
                }
                content.append("付款方式：").append(payTypeText).append("<BR>");
                content.append("付款时间：").append(DateUtils.format(orderInfo.getPayTime(), DateUtils.DATE_TIME_PATTERN)).append("<BR>");
                // 二维码是订单编号
                content.append("<QR>").append(orderInfo.getOrderSn()).append("</QR>");

                //获取门店的打印机编号，每个门店只有一个打票机
                SysPrinterEntity printerEntity = printerService.getOne(new QueryWrapper<SysPrinterEntity>().eq("SHOPS_ID", orderInfo.getShopsId()), false);
                if (null != printerEntity) {
                    // 第一次打印
                    PrintUtils.printMsg(printerEntity.getSn(), content.toString(), "1");
                    content.append("<RIGHT><BOLD>【存根】</BOLD></RIGHT>");
                    content.append("<CUT>");

                    // 第二次存根打印
                    PrintUtils.printMsg(StringUtils.isNotBlank(printerEntity.getStubSn()) ? printerEntity.getStubSn() : printerEntity.getSn(), content.toString(), "1");
                }

                // 拼团业务
                if (Constant.GROUP_ORDER.equals(orderInfo.getOrderType())) {
                    addGroupBuyingRecord(orderInfo);
                }
                // 判断是否拥有分销商并添加分销订单
                if (Constant.NORMAL_ORDER.equals(orderInfo.getOrderType())) {
                    mallDistOrderService.addDistOrder(orderInfo.getUserId(), orderInfo.getId());
                }

                try {
                    // 支付成功、 订单总金额(单位：分) 除以100保留两位小数
                    BigDecimal totalFee = orderInfo.getActualPrice().divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP);
                    MallUserEntity malluserentity = userService.getById(orderInfo.getUserId());
                    // 增加购物积分 消费金额与购物积分1：1增加
                    if (null != malluserentity) {
                        malluserentity.setIntegral(malluserentity.getIntegral() + totalFee.intValue());
                        userService.update(malluserentity);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                try {
                    // 微信通知
                    if (orderInfo.getFromType().equals(Constant.FromType.MA.getValue())) {
                        sendMsgService.notifyPaySuccess(orderInfo, 1);
                    } else if (orderInfo.getFromType().equals(Constant.FromType.MP.getValue())) {
                        //TODO 公众号下单，发送消息
                    } else if (orderInfo.getFromType().equals(Constant.FromType.QQ.getValue())) {
                        //TODO QQ下单，发送消息
                    } else if (orderInfo.getFromType().equals(Constant.FromType.ALI.getValue())) {
                        //TODO 支付宝下单，发送消息
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
        return setXml(Constant.SUCCESS, "OK");
    }

    /**
     * 返回微信服务
     *
     * @param returnCode
     * @param returnMsg
     * @return
     */
    public String setXml(String returnCode, String returnMsg) {
        return "<xml><return_code><![CDATA[" + returnCode + "]]></return_code><return_msg><![CDATA[" + returnMsg + "]]></return_msg></xml>";
    }

    /**
     * 余额充值统一下单请求
     *
     * @param loginUser
     * @param jsonParam
     * @return
     */
    public RestResponse prepayYue(MallUserEntity loginUser, JSONObject jsonParam) {
        BigDecimal price = jsonParam.getBigDecimal("price");
        Integer fromType = jsonParam.getInteger("fromType");
        String tradeType = jsonParam.getString("tradeType");

        MallAccountLogEntity accountLogEntity = new MallAccountLogEntity();
        accountLogEntity.setAddTime(new Date());
        accountLogEntity.setUserId(loginUser.getId());
        accountLogEntity.setPrice(price);
        accountLogEntity.setLogDesc("用户余额充值");
        accountLogEntity.setType(0);
        accountLogEntity.setOrderType(0);
        accountLogEntity.setFromType(fromType);
        accountLogEntity.setOrderSn(StringUtils.generateOrderNumber());
        accountLogService.save(accountLogEntity);
        try {
            WxPayMpOrderResult data = null;
            if (ObjectUtils.equals(accountLogEntity.getFromType(), Constant.FromType.MP.getValue())
                    || ObjectUtils.equals(accountLogEntity.getFromType(), Constant.FromType.MA.getValue())) {

                WxPayUnifiedOrderRequest request = new WxPayUnifiedOrderRequest();
                request.setBody("本次充值金额：" + price + "元");
                request.setOutTradeNo(accountLogEntity.getOrderSn());
                //支付金额
                request.setTotalFee(BaseWxPayRequest.yuanToFen(price.toString()));
                request.setSpbillCreateIp(spbillCreateIp);
                // 回调地址
                request.setNotifyUrl(baseNotifyUrl + "/app/pay/prepayYueNotify");
                // 交易类型APP
                request.setTradeType(tradeType);
                request.setOpenid(loginUser.getOpenId());

                //调用统一下单接口，并组装生成支付所需参数对象
                data = wxPayService.createOrder(request);
            }
            if (ObjectUtils.equals(accountLogEntity.getFromType(), Constant.FromType.QQ.getValue())) {
                //todo QQ钱包支付
            }
            return RestResponse.success().put("data", data);
        } catch (Exception e) {
            e.printStackTrace();
            return RestResponse.error("下单失败,error=" + e.getMessage());
        }
    }

    /**
     * 余额统一下单请求回调接口
     *
     * @param xmlData
     * @return
     */
    public String prepayYueNotify(String xmlData) {
        try {
            WxPayOrderNotifyResult result = wxPayService.parseOrderNotifyResult(xmlData);
            String resultCode = result.getResultCode();
            //订单编号
            String outTradeNo = result.getOutTradeNo();
            if (resultCode.equalsIgnoreCase(Constant.FAIL)) {
                log.error("充值订单：" + outTradeNo + "支付失败");
                return setXml(Constant.SUCCESS, "OK");
            } else if (resultCode.equalsIgnoreCase(Constant.SUCCESS)) {
                log.error("充值订单" + outTradeNo + "支付成功");
                // 业务处理
                MallAccountLogEntity accountLogEntity = accountLogService.getOne(new QueryWrapper<MallAccountLogEntity>().eq("ORDER_SN", outTradeNo));
                // 已经支付,不再执行
                if (accountLogEntity.getType() == 1) {
                    return setXml(Constant.SUCCESS, "OK");
                }
                accountLogEntity.setType(1);
                accountLogEntity.setAddTime(new Date());
                accountLogService.update(accountLogEntity);

                if (accountLogEntity.getOrderType() == 0) {
                    MallUserEntity userEntity = userService.getById(accountLogEntity.getUserId());
                    userEntity.setBalance(userEntity.getBalance().add(accountLogEntity.getPrice()));
                    userService.update(userEntity);
                }
                if (Constant.FromType.MA.getValue().equals(accountLogEntity.getFromType())) {
                    // TODO 微信通知
                } else if (accountLogEntity.getFromType().equals(Constant.FromType.MP.getValue())) {
                    //TODO 公众号下单，发送消息
                } else if (accountLogEntity.getFromType().equals(Constant.FromType.QQ.getValue())) {
                    //TODO QQ下单，发送消息
                }
            } else {
                log.error("充值订单处理异常");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return setXml(Constant.SUCCESS, "OK");
    }

    /**
     * 生成扫码支付二维码
     *
     * @return
     * @throws Exception
     */
    public byte[] generateQrCode() throws Exception {
        String productId = StringUtils.generateOrderNumber();

        String content = wxPayService.createScanPayQrcodeMode1(productId);
        return QrcodeUtils.createQrcode(content, null);
    }

    /**
     * 扫码支付回调通知处理
     *
     * @param xmlData
     * @return
     */
    public Object parseScanPayNotifyResult(String xmlData) {
        try {
            final WxScanPayNotifyResult result = wxPayService.parseScanPayNotifyResult(xmlData);
            String productId = result.getProductId();
            MallOrderEntity orderInfo = orderService.getOne(new QueryWrapper<MallOrderEntity>().eq("ORDER_SN", productId));
            WxPayUnifiedOrderRequest request = new WxPayUnifiedOrderRequest();
            String goodsId = orderInfo.getGoodsId();
            MallGoodsEntity goods = goodsService.getById(goodsId);

            request.setBody(goods.getName() + orderInfo.getActualPrice() + "元");
            request.setOutTradeNo(productId);
            request.setProductId(productId);
            //支付金额
            request.setTotalFee(BaseWxPayRequest.yuanToFen(orderInfo.getActualPrice().toString()));
            request.setSpbillCreateIp(spbillCreateIp);
            // 回调地址
            request.setNotifyUrl(baseNotifyUrl + "/app/pay/parseOrderNotifyResult");
            // 交易类型APP
            request.setTradeType("NATIVE");
            request.setOpenid(result.getOpenid());

            //统一下单接口，在发起微信支付前，需要调用统一下单接口，获取"预支付交易会话标识"
            WxPayUnifiedOrderResult unifiedOrderResult = wxPayService.unifiedOrder(request);

            //记录prepayId
            orderInfo.setPrepayId(unifiedOrderResult.getPrepayId());
            orderService.update(orderInfo);

            XStream xstream = XStreamInitializer.getInstance();
            xstream.autodetectAnnotations(true);

            return unifiedOrderResult;
        } catch (WxPayException e) {
            e.printStackTrace();
        }
        return WxPayNotifyResponse.success("成功");
    }

    /**
     * 扫码支付结果
     *
     * @param xmlData
     * @return
     */
    public String parseOrderNotifyResult(String xmlData) {
        try {
            WxPayOrderNotifyResult result = wxPayService.parseOrderNotifyResult(xmlData);
            String resultCode = result.getResultCode();
            String outTradeNo = result.getOutTradeNo();
            if (resultCode.equalsIgnoreCase(Constant.FAIL)) {
                //订单编号
                log.info("扫码支付订单" + outTradeNo + "支付失败");
                return setXml(Constant.SUCCESS, "OK");
            } else if (resultCode.equalsIgnoreCase(Constant.SUCCESS)) {
                log.info("扫码支付订单" + outTradeNo + "支付成功");
                // 业务处理
                MallOrderEntity orderInfo = orderService.getOne(new QueryWrapper<MallOrderEntity>().eq("ORDER_SN", outTradeNo));
                // 已经支付,不再执行
                if (null == orderInfo || orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
                    return setXml(Constant.SUCCESS, "OK");
                }
                orderInfo.setPayStatus(Constant.PayStatus.YFK.getValue());
                orderInfo.setPayTime(new Date());
                if (orderInfo.getOrderStatus().equals(Constant.OrderStatus.DFK.getValue())) {
                    orderInfo.setOrderStatus(Constant.OrderStatus.YFK.getValue());
                }
                orderService.update(orderInfo);

                // 判断是否拥有分销商并添加分销订单
                mallDistOrderService.addDistOrder(orderInfo.getUserId(), orderInfo.getId());

            } else {
                log.error("扫码支付订单处理异常");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return setXml(Constant.SUCCESS, "OK");
    }

    /**
     * 退款回调通知处理
     *
     * @param xmlData
     * @return
     */
    public String parseRefundNotifyResult(String xmlData) {
        try {
            WxPayRefundNotifyResult result = this.wxPayService.parseRefundNotifyResult(xmlData);
            log.info("退款订单，result：" + result.toString());
            String returnCode = result.getReturnCode();
            String outTradeNo = result.getReqInfo().getOutTradeNo();
            //退款金额 分
            Integer refundFee = result.getReqInfo().getRefundFee();

            if (returnCode.equalsIgnoreCase(Constant.FAIL)) {
                //订单编号
                log.info("订单" + outTradeNo + "退款失败");
                return setXml(Constant.SUCCESS, "OK");
            } else if (returnCode.equalsIgnoreCase(Constant.SUCCESS)) {
                log.info("订单" + outTradeNo + "退款成功");
                // 业务处理
                MallOrderEntity orderInfo = orderService.getOne(new QueryWrapper<MallOrderEntity>().eq("ORDER_SN", outTradeNo));
                // 已经退款,不再执行
                if (null == orderInfo || orderInfo.getPayStatus().equals(Constant.PayStatus.TK.getValue())) {
                    return setXml(Constant.SUCCESS, "OK");
                }
                orderInfo.setPayStatus(Constant.PayStatus.TK.getValue());
                //订单已发货 退款
                if (orderInfo.getOrderStatus().equals(Constant.OrderStatus.YFH.getValue())) {
                    orderInfo.setOrderStatus(Constant.OrderStatus.THTK.getValue());
                } else {
                    //订单已收货 退款
                    orderInfo.setOrderStatus(Constant.OrderStatus.TK.getValue());
                }
                orderService.update(orderInfo);

                MallUserEntity malluserentity = userService.getById(orderInfo.getUserId());
                malluserentity.setBalance(malluserentity.getBalance().subtract(new BigDecimal(refundFee / 100)));
                userService.update(malluserentity);
            } else {
                log.error("订单退款处理异常");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return setXml(Constant.SUCCESS, "OK");
    }

    /**
     * 申请退款
     *
     * @param orderSaleservice
     * @return
     */
    public boolean applyRefund(MallOrderSaleserviceEntity orderSaleservice) {

        String orderSn = orderSaleservice.getOrderSn();
        MallOrderSaleserviceEntity saleserviceEntity = orderSaleserviceService.getByOrderSn(orderSn);
        if (null != saleserviceEntity) {
            throw new BusinessException("请勿重复申请！");
        }
        MallOrderEntity orderVo = orderService.getOne(new LambdaQueryWrapper<MallOrderEntity>().eq(MallOrderEntity::getOrderSn, orderSn));
        if (!orderSaleservice.getUserId().equals(orderVo.getUserId())) {
            throw new BusinessException("越权操作！");
        }
        // 退款金额>实际支付金额
        if (orderSaleservice.getAmount().compareTo(orderVo.getActualPrice()) > 0) {
            throw new BusinessException("退款金额不能大于实付金额！");
        }

        // 允许退货的期限
        int refundTime = Integer.parseInt(sysConfigService.getValue(Constant.ALLOW_REFUND_TIME, "7"));

        if (new Date().after(DateUtils.addDateDays(orderVo.getPayTime(), refundTime))) {
            throw new BusinessException("超出可退款时间！");
        }
        orderVo.setOrderStatus(Constant.OrderStatus.SQTK.getValue());
        orderService.update(orderVo);

        orderSaleservice.setStatus(1);
        orderSaleservice.setCreateTime(new Date());
        orderSaleservice.setSaleserviceSn("TK" + StringUtils.generateOrderNumber());
        return orderSaleserviceService.add(orderSaleservice);
    }

    /**
     * 支付宝统一下单请求(app 支付)
     */
    public RestResponse aliPrepay(MallUserEntity loginUser, JSONObject jsonParam) {
        String orderId = jsonParam.getString("orderId");

        MallOrderEntity orderInfo = orderService.getById(orderId);
        if (null == orderInfo) {
            return RestResponse.error("订单已取消！");
        }
        if (!loginUser.getId().equals(orderInfo.getUserId())) {
            return RestResponse.error("非法操作！");
        }
        if (orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            return RestResponse.error("订单已支付，请不要重复操作！");
        }

        Map<String, Object> orderGoodsParam = new HashMap<>(2);
        orderGoodsParam.put("orderId", orderId);
        //订单的商品
        List<MallOrderGoodsEntity> orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        if (null == orderGoods || orderGoods.size() == 0) {
            // 父级订单下的子订单商品
            orderGoodsParam = new HashMap<>(2);
            orderGoodsParam.put("parentId", orderId);
            orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        }
        StringBuilder body = new StringBuilder();
        if (null != orderGoods && orderGoods.size() > 0) {
            for (MallOrderGoodsEntity goodsVo : orderGoods) {
                if (body.toString().getBytes(StandardCharsets.UTF_8).length < 90) {
                    body.append(goodsVo.getGoodsName()).append("*").append(goodsVo.getNumber()).append("、");
                } else {
                    body.append("...");
                }
            }
            if (body.length() > 0) {
                body = new StringBuilder(body.substring(0, body.length() - 1));
            }
        }
        int orderExpire = Integer.parseInt(sysConfigService.getValue(Constant.ORDER_EXPIRE, "30"));
        try {
            AlipayTradeAppPayResponse response = aliPayService.createAppTradeForm(body.toString(), orderInfo.getOrderSn(), orderInfo.getOrderPrice().toString(), orderExpire + "m");

            // 添加分销订单
            if (orderInfo.getOrderType() == 1) {
                mallDistOrderService.addDistOrder(loginUser.getId(), orderInfo.getId());
            }
            return RestResponse.success().put("data", response.getBody());
        } catch (Exception e) {
            e.printStackTrace();
            return RestResponse.error("下单失败,error=" + e.getMessage());
        }
    }

    /**
     * 支付宝统一下单请求(app 支付)
     */
    public RestResponse aliPrepayMa(MallUserEntity loginUser, JSONObject jsonParam) {
        String orderId = jsonParam.getString("orderId");

        MallOrderEntity orderInfo = orderService.getById(orderId);
        if (null == orderInfo) {
            return RestResponse.error("订单已取消！");
        }
        if (!loginUser.getId().equals(orderInfo.getUserId())) {
            return RestResponse.error("非法操作！");
        }
        if (orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            return RestResponse.error("订单已支付，请不要重复操作！");
        }

        Map<String, Object> orderGoodsParam = new HashMap<>(2);
        orderGoodsParam.put("orderId", orderId);
        //订单的商品
        List<MallOrderGoodsEntity> orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        if (null == orderGoods || orderGoods.size() == 0) {
            // 父级订单下的子订单商品
            orderGoodsParam = new HashMap<>(2);
            orderGoodsParam.put("parentId", orderId);
            orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        }
        StringBuilder body = new StringBuilder();
        if (null != orderGoods && orderGoods.size() > 0) {
            for (MallOrderGoodsEntity goodsVo : orderGoods) {
                if (body.toString().getBytes(StandardCharsets.UTF_8).length < 90) {
                    body.append(goodsVo.getGoodsName()).append("*").append(goodsVo.getNumber()).append("、");
                } else {
                    body.append("...");
                }
            }
            if (body.length() > 0) {
                body = new StringBuilder(body.substring(0, body.length() - 1));
            }
        }
        int orderExpire = Integer.parseInt(sysConfigService.getValue(Constant.ORDER_EXPIRE, "30"));
        try {
            AlipayTradeCreateResponse response = aliPayService.create(body.toString(), orderInfo.getOrderSn(), orderInfo.getOrderPrice().toString(), loginUser.getAliUserId(), orderExpire + "m");

            // 添加分销订单
            if (orderInfo.getOrderType() == 1) {
                mallDistOrderService.addDistOrder(loginUser.getId(), orderInfo.getId());
            }
            return RestResponse.success().put("data", response.getTradeNo());
        } catch (Exception e) {
            e.printStackTrace();
            return RestResponse.error("下单失败,error=" + e.getMessage());
        }
    }

    /**
     * 支付宝统一下单请求(wap web支付)
     */
    public String aliPrepayH5(MallUserEntity loginUser, String orderId, String returnUrl) {
        MallOrderEntity orderInfo = orderService.getById(orderId);
        if (null == orderInfo) {
            throw new BusinessException("订单已取消！");
        }
        if (!loginUser.getId().equals(orderInfo.getUserId())) {
            throw new BusinessException("非法操作！");
        }
        if (orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            throw new BusinessException("订单已支付，请不要重复操作！");
        }

        Map<String, Object> orderGoodsParam = new HashMap<>(2);
        orderGoodsParam.put("orderId", orderId);
        //订单的商品
        List<MallOrderGoodsEntity> orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        if (null == orderGoods || orderGoods.size() == 0) {
            // 父级订单下的子订单商品
            orderGoodsParam = new HashMap<>(2);
            orderGoodsParam.put("parentId", orderId);
            orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        }
        StringBuilder body = new StringBuilder();
        if (null != orderGoods && orderGoods.size() > 0) {
            for (MallOrderGoodsEntity goodsVo : orderGoods) {
                if (body.toString().getBytes(StandardCharsets.UTF_8).length < 90) {
                    body.append(goodsVo.getGoodsName()).append("*").append(goodsVo.getNumber()).append("、");
                } else {
                    body.append("...");
                }
            }
            if (body.length() > 0) {
                body = new StringBuilder(body.substring(0, body.length() - 1));
            }
        }
        int orderExpire = Integer.parseInt(sysConfigService.getValue(Constant.ORDER_EXPIRE, "30"));
        try {
            AlipayTradePagePayResponse pagePayResponse = aliPayService.createWebTradeForm(body.toString(), orderInfo.getOrderSn(), orderInfo.getActualPrice().toString(), returnUrl, orderExpire + "m");

            // 添加分销订单
            if (orderInfo.getOrderType() == 1) {
                mallDistOrderService.addDistOrder(loginUser.getId(), orderInfo.getId());
            }

            return pagePayResponse.getBody();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 支付宝统一下单请求(wap web支付)
     */
    public String aliPrepayWap(MallUserEntity loginUser, String orderId, String returnUrl) {
        MallOrderEntity orderInfo = orderService.getById(orderId);
        if (null == orderInfo) {
            throw new BusinessException("订单已取消！");
        }
        if (!loginUser.getId().equals(orderInfo.getUserId())) {
            throw new BusinessException("非法操作！");
        }
        if (orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            throw new BusinessException("订单已支付，请不要重复操作！");
        }

        Map<String, Object> orderGoodsParam = new HashMap<>(2);
        orderGoodsParam.put("orderId", orderId);
        //订单的商品
        List<MallOrderGoodsEntity> orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        if (null == orderGoods || orderGoods.size() == 0) {
            // 父级订单下的子订单商品
            orderGoodsParam = new HashMap<>(2);
            orderGoodsParam.put("parentId", orderId);
            orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        }
        StringBuilder body = new StringBuilder();
        if (null != orderGoods && orderGoods.size() > 0) {
            for (MallOrderGoodsEntity goodsVo : orderGoods) {
                if (body.toString().getBytes(StandardCharsets.UTF_8).length < 90) {
                    body.append(goodsVo.getGoodsName()).append("*").append(goodsVo.getNumber()).append("、");
                } else {
                    body.append("...");
                }
            }
            if (body.length() > 0) {
                body = new StringBuilder(body.substring(0, body.length() - 1));
            }
        }
        int orderExpire = Integer.parseInt(sysConfigService.getValue(Constant.ORDER_EXPIRE, "30"));
        try {
            AlipayTradeWapPayResponse pagePayResponse = aliPayService.createWapTradeForm(body.toString(), orderInfo.getOrderSn(), orderInfo.getActualPrice().toString(), returnUrl, orderExpire + "m");

            // 添加分销订单
            if (orderInfo.getOrderType() == 1) {
                mallDistOrderService.addDistOrder(loginUser.getId(), orderInfo.getId());
            }

            return pagePayResponse.getBody();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 支付宝支付通知
     *
     * @param request
     * @return
     */
    public String aliNotify(HttpServletRequest request) {
        try {
            Map<String, String> params = getAllRequestParam(request);
            if (!Factory.Payment.Common().verifyNotify(params)) {
                log.error("校验失败");
                return "fail";
            }
            log.info("----------支付宝统一下单请求回调接口参数：----------");
            log.info(params.toString());
            String trade_status = params.get("trade_status");

            if (trade_status.equals("TRADE_SUCCESS")) {
                String outTradeNo = URLDecoder.decode(params.get("out_trade_no"), "UTF-8");
                log.info("支付成功：" + trade_status);
                notifySuccess(outTradeNo, Constant.PayType.ZFB.getValue());
                return "success";
            }
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
        return "fail";
    }

    //得到请求的参数
    private Map<String, String> getAllRequestParam(final HttpServletRequest request) {
        Map<String, String> res = new HashMap<>();
        Enumeration<?> temp = request.getParameterNames();
        while (temp.hasMoreElements()) {
            String en = (String) temp.nextElement();
            String value = request.getParameter(en);
            res.put(en, value);
        }
        return res;
    }

    /**
     * 添加拼团记录
     *
     * @param order
     */
    public void addGroupBuyingRecord(MallOrderEntity order) {
        List<MallOrderGoodsEntity> list = orderGoodsService.getGoodsList(order.getId());
        MallUserEntity userEntity = userService.getById(order.getUserId());
        MallGoodsEntity goods = goodsService.getById(order.getGoodsId());

        MallGroupBuyingRecordEntity buyingRecordEntity = new MallGroupBuyingRecordEntity();
        buyingRecordEntity.setGoodsId(order.getGoodsId());
        buyingRecordEntity.setGoodsDetail(list.get(0).getGoodsSpecifitionNameValue());
        buyingRecordEntity.setOrderSn(order.getOrderSn());
        buyingRecordEntity.setUserId(order.getUserId());
        buyingRecordEntity.setNickname(userEntity.getNickname());
        buyingRecordEntity.setHeadImgUrl(userEntity.getHeadImgUrl());
        buyingRecordEntity.setExpireTime(DateUtils.addDateMinutes(new Date(), Integer.parseInt(sysConfigService.getValue(Constant.ORDER_EXPIRE, "30"))));
        buyingRecordEntity.setPrice(order.getActualPrice());

        // 团ID
        String groupId = order.getGroupId();
        // 发起拼团
        if (StringUtils.isEmpty(groupId)) {
            buyingRecordEntity.setIsLeader(1);
            buyingRecordEntity.setLeaderId("0");
            buyingRecordEntity.setJoinNumber(1);
            buyingRecordEntity.setStatus(1);
            buyingRecordService.add(buyingRecordEntity);
        } else {
            /**
             * 主团信息
             */
            MallGroupBuyingRecordEntity leader = buyingRecordService.getById(groupId);
            if (leader.getStatus() != 1 || leader.getJoinNumber() >= goods.getGroupNumber()) {
                throw new BusinessException("团已结束！");
            }

            /**
             * 参与的新团
             */
            buyingRecordEntity.setUpdateTime(new Date());
            buyingRecordEntity.setIsLeader(0);
            buyingRecordEntity.setJoinNumber(leader.getJoinNumber());
            buyingRecordEntity.setLeaderId(groupId);
            buyingRecordService.add(buyingRecordEntity);

            // leaderId下所有参团人数+1
            buyingRecordService.addJoinNumber(groupId);

            leader.setUpdateTime(new Date());
            leader.setJoinNumber(leader.getJoinNumber() + 1);
            buyingRecordService.updateById(leader);

            // 成团
            if (leader.getJoinNumber().equals(goods.getGroupNumber())) {
                // 所有团设置为成功
                buyingRecordService.updateStatus(groupId, 2);
            }
        }
    }
}

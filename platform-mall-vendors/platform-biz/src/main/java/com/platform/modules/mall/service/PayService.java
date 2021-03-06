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
 * @author ?????????
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
     * ??????
     *
     * @param orderVo
     * @param refundFee ???????????????????????????
     * @return
     */
    public RestResponse refund(MallOrderEntity orderVo, String refundFee) {
        if (orderVo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            String orderSn = orderVo.getOrderSn();
            // ?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
            String outRefundNo = orderVo.getOrderSn();
            boolean flag = false;

            BigDecimal actualPrice = orderVo.getActualPrice();
            // ???????????????????????????????????????ID???????????????????????????
            if (StringUtils.isNotBlank(orderVo.getParentId()) && !"????????????".equals(orderVo.getParentId()) && !"????????????".equals(orderVo.getParentId())) {
                outRefundNo = "TK" + StringUtils.generateOrderNumber();
                orderSn = orderVo.getParentId();
                // ????????????????????????
                actualPrice = orderService.getById(orderSn).getActualPrice();
            }

            //??????????????????
            if (Constant.PayType.WX.getValue().equals(orderVo.getPayType())) {
                WxPayRefundRequest request = new WxPayRefundRequest();
                request.setOutRefundNo(outRefundNo);
                request.setOutTradeNo(orderSn);
                request.setTotalFee(BaseWxPayRequest.yuanToFen(actualPrice.toString()));
                request.setRefundFee(BaseWxPayRequest.yuanToFen(refundFee));
                request.setRefundDesc("??????????????????");
                WxPayRefundResult result;
                try {
                    result = wxPayService.refundV2(request);
                } catch (WxPayException e) {
                    throw new BusinessException("???????????????" + e.getErrCode());
                }
                if (result.getResultCode().equals(Constant.SUCCESS)) {
                    flag = true;
                }
            }

            // ?????????????????????
            if (Constant.PayType.ZFB.getValue().equals(orderVo.getPayType())) {
                AlipayTradeRefundResponse response;
                try {
                    response = aliPayService.refundTrade(orderSn, refundFee, outRefundNo);
                } catch (Exception e) {
                    throw new BusinessException("???????????????" + e.getMessage());
                }
                if (response.getMsg().equalsIgnoreCase(Constant.SUCCESS)) {
                    flag = true;
                }
            }
            MallUserEntity mallUserEntity = userService.getById(orderVo.getUserId());
            // ????????????
            if (Constant.PayType.YE.getValue().equals(orderVo.getPayType())) {
                MallAccountLogEntity accountLogEntity = new MallAccountLogEntity();
                accountLogEntity.setLogDesc("??????");
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

                //?????????????????????
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
                    saleService.setReason("??????????????????????????????");
                    saleService.setAmount(new BigDecimal(refundFee));
                    saleService.setStatus(3);
                    saleService.setCreateTime(new Date());
                    saleService.setHandleTime(new Date());
                    saleService.setRefundTime(new Date());
                    saleService.setHandleReason("????????????");
                    orderSaleserviceService.save(saleService);
                }

                //??????????????????????????????
                goodsService.backGoodsNumber(orderVo);
                //???????????????
                if (StringUtils.isNotBlank(orderVo.getCouponId())) {
                    userCouponService.backCoupon(orderVo.getId());
                }
                Integer totaRefundlFee = Integer.parseInt(refundFee.split("\\.")[0]);
                // ????????????????????????
                // ????????????????????????????????????????????????????????????????????????
                if (Constant.PayType.WX.getValue().equals(orderVo.getPayType()) || Constant.PayType.ZFB.getValue().equals(orderVo.getPayType())) {
                    // ?????????????????????0????????????0
                    if (mallUserEntity.getIntegral() < totaRefundlFee) {
                        mallUserEntity.setIntegral(0);
                    } else {
                        mallUserEntity.setIntegral(mallUserEntity.getIntegral() - totaRefundlFee);
                    }
                    userService.update(mallUserEntity);
                }
                return RestResponse.success("???????????????");
            } else {
                return RestResponse.error("???????????????");
            }
        } else {
            orderVo.setOrderStatus(Constant.OrderStatus.YQX.getValue());
            orderService.update(orderVo);
            //??????????????????????????????
            goodsService.backGoodsNumber(orderVo);
            //???????????????
            if (StringUtils.isNotBlank(orderVo.getCouponId())) {
                userCouponService.backCoupon(orderVo.getId());
            }
            return RestResponse.success("???????????????");
        }
    }

    /**
     * ?????????
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

                //??????????????????????????????????????????????????????????????????
                WxPayUnifiedOrderRequest request = new WxPayUnifiedOrderRequest();
                request.setBody("??????????????????" + loginUser.getNickname());
                request.setOutTradeNo(orderSn);
                //????????????
                request.setTotalFee(BaseWxPayRequest.yuanToFen(money));
                request.setSpbillCreateIp(spbillCreateIp);
                // ????????????
                request.setNotifyUrl(baseNotifyUrl + "/app/pay/faceToFaceNotify");
                // ????????????APP
                request.setTradeType(tradeType);
                if (ObjectUtils.equals(tradeType, "MWEB")) {
                    //??????H5??????
                    mwebOrderResult = wxPayService.createOrder(request);
                } else if (ObjectUtils.equals(tradeType, "APP")) {
                    //APP??????
                    request.setAppid(appAppId);
                    appOrderResult = wxPayService.createOrder(request);
                } else {
                    //???????????????????????????
                    if (fromType.equals(Constant.FromType.MP.getValue())) {
                        // ?????????????????????
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
            return RestResponse.error("????????????,error=" + e.getErrCodeDes());
        }
    }

    /**
     * ?????????????????????
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
                //????????????
                log.error("??????" + outTradeNo + "????????????");
                return setXml(Constant.SUCCESS, "OK");
            } else if (resultCode.equalsIgnoreCase(Constant.SUCCESS)) {
                //????????????
                log.error("??????" + outTradeNo + "????????????");
                // ????????????
                MallPayFaceToFaceEntity payFaceToFaceEntity = payFaceToFaceService.getOne(new QueryWrapper<MallPayFaceToFaceEntity>().eq("ORDER_SN", outTradeNo));
                // ????????????,????????????
                if (payFaceToFaceEntity.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
                    return setXml(Constant.SUCCESS, "OK");
                }
                payFaceToFaceEntity.setPayStatus(Constant.PayStatus.YFK.getValue());
                payFaceToFaceEntity.setPayTime(new Date());

                MallShopsEntity shopsEntity = shopsService.getById(payFaceToFaceEntity.getShopsId());
                MallUserEntity userEntity = userService.getById(payFaceToFaceEntity.getUserId());

                StringBuilder content = new StringBuilder("<CB>????????????</CB><BR>");
                content.append("????????????").append(payFaceToFaceEntity.getOrderSn()).append("<BR>");
                content.append("??????????????????").append(shopsEntity.getName()).append("???<BR>");
                content.append("--------------------------------<BR>");
                content.append("???????????????").append(userEntity.getNickname()).append("<BR>");
                content.append("???????????????").append(payFaceToFaceEntity.getActualPrice()).append("<BR>");
                content.append("???????????????").append(DateUtils.format(payFaceToFaceEntity.getPayTime(), DateUtils.DATE_TIME_PATTERN)).append("<BR>");
                // ????????????????????????
                content.append("<QR>").append(payFaceToFaceEntity.getOrderSn()).append("</QR>");

                //??????????????????????????????????????????????????????????????????
                SysPrinterEntity printerEntity = printerService.getOne(new QueryWrapper<SysPrinterEntity>().eq("SHOPS_ID", payFaceToFaceEntity.getShopsId()), false);
                if (null != printerEntity) {
                    // ???????????????
                    PrintUtils.printMsg(printerEntity.getSn(), content.toString(), "1");
                    content.append("<RIGHT><BOLD>????????????</BOLD></RIGHT>");
                    content.append("<CUT>");

                    // ?????????????????????
                    PrintUtils.printMsg(StringUtils.isNotBlank(printerEntity.getStubSn()) ? printerEntity.getStubSn() : printerEntity.getSn(), content.toString(), "1");
                }
                payFaceToFaceService.update(payFaceToFaceEntity);

                // ??????????????? ???????????????(????????????) ??????100??????????????????
                BigDecimal totalFee = new BigDecimal(result.getTotalFee()).divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP);
                // ?????????????????? ???????????????????????????1???1??????
                userEntity.setIntegral(userEntity.getIntegral() + totalFee.intValue());
                userService.update(userEntity);
            } else {
                log.error("??????????????????");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return setXml(Constant.SUCCESS, "OK");
    }

    /**
     * ????????????????????????
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
            return RestResponse.error("??????????????????");
        }
        if (!loginUser.getId().equals(orderInfo.getUserId())) {
            return RestResponse.error("???????????????");
        }
        if (orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            return RestResponse.error("??????????????????????????????????????????");
        }

        Map<String, Object> orderGoodsParam = new HashMap<>(2);
        orderGoodsParam.put("orderId", orderId);
        //???????????????
        List<MallOrderGoodsEntity> orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        if (null == orderGoods || orderGoods.size() == 0) {
            // ?????????????????????????????????
            orderGoodsParam = new HashMap<>(2);
            orderGoodsParam.put("parentId", orderId);
            orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        }
        StringBuilder body = new StringBuilder();
        if (null != orderGoods && orderGoods.size() > 0) {
            for (MallOrderGoodsEntity goodsVo : orderGoods) {
                if (body.toString().getBytes(StandardCharsets.UTF_8).length < 90) {
                    body.append(goodsVo.getGoodsName()).append("*").append(goodsVo.getNumber()).append("???");
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
            //????????????
            if (ObjectUtils.equals(tradeType, "JSAPI") || ObjectUtils.equals(tradeType, "APP")
                    || ObjectUtils.equals(tradeType, "MWEB")) {

                //??????????????????????????????????????????????????????????????????
                WxPayUnifiedOrderRequest request = new WxPayUnifiedOrderRequest();
                request.setBody(body.toString());
                request.setOutTradeNo(orderInfo.getOrderSn());
                //????????????
                request.setTotalFee(BaseWxPayRequest.yuanToFen(orderInfo.getActualPrice().toString()));
                request.setSpbillCreateIp(spbillCreateIp);
                // ????????????
                request.setNotifyUrl(baseNotifyUrl + "/app/pay/notify");
                // ????????????APP
                request.setTradeType(tradeType);
                try {
                    if (ObjectUtils.equals(tradeType, "MWEB")) {
                        //??????H5??????
                        mwebOrderResult = wxPayService.createOrder(request);
                    } else if (ObjectUtils.equals(tradeType, "APP")) {
                        //APP??????
                        request.setAppid(appAppId);
                        appOrderResult = wxPayService.createOrder(request);
                    } else {
                        //???????????????????????????
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
                     * ??????:??????????????????OUT_TRADE_NO_USED:?????????????????????
                     *
                     * ??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????201 ??????????????????????????????????????????
                     * ????????????????????????????????????????????????????????????out_trade_no?????????????????????????????????????????????????????????????????????????????????????????????
                     * ?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
                     * ???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
                     * ?????????????????????????????????????????????XG
                     */
                    if (e.getErrCodeDes() != null && e.getErrCodeDes().contains("?????????????????????")) {
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
                        return RestResponse.error("????????????,error=" + e.getReturnMsg());
                    }
                }
            }
            //QQ????????????
            if (ObjectUtils.equals(orderInfo.getFromType(), Constant.FromType.QQ.getValue())) {
                Map<Object, Object> request = new TreeMap<>();
                request.put("appid", appid);
                request.put("mch_id", mchId);
                // ????????????
                request.put("body", body.toString());
                request.put("nonce_str", CharUtil.getRandomNum(18).toUpperCase());
                // ????????????
                String sign = QqPayUtils.arraySign(request, mchKey);
                request.put("sign", sign);

                // ????????????
                request.put("notify_url", baseNotifyUrl + "/app/pay/notify");
                request.put("out_trade_no", orderInfo.getOrderSn());
                request.put("spbill_create_ip", spbillCreateIp);
                //????????????
                request.put("total_fee", BaseWxPayRequest.yuanToFen(orderInfo.getActualPrice().toString()));
                // ????????????APP
                request.put("trade_type", tradeType);

                request.put("fee_type", "CNY");

                String xml = QqPayUtils.convertMap2Xml(request);
                String url = "https://qpay.qq.com/cgi-bin/pay/qpay_unified_order.cgi";

                String responseContent = wxPayService.post(url, xml, false);
                WxPayUnifiedOrderResult unifiedOrderResult = BaseWxPayResult.fromXML(responseContent, WxPayUnifiedOrderResult.class);

                //??????prepayId
                orderInfo.setPrepayId(unifiedOrderResult.getPrepayId());
                orderService.update(orderInfo);

                data = QqPayUtils.createOrder(unifiedOrderResult, request, mchKey);
            }

            // ??????????????????
            if (orderInfo.getOrderType() == 1) {
                mallDistOrderService.addDistOrder(loginUser.getId(), orderInfo.getId());
            }

            return RestResponse.success().put("data", data).put("mwebOrderResult", mwebOrderResult).put("appOrderResult", appOrderResult);
        } catch (WxPayException e) {
            e.printStackTrace();
            return RestResponse.error("????????????,error=" + e.getErrCodeDes());
        }
    }

    /**
     * ????????????????????????????????????
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
                //????????????
                log.error("??????" + outTradeNo + "????????????");
                return setXml(Constant.SUCCESS, "OK");
            } else if (resultCode.equalsIgnoreCase(Constant.SUCCESS)) {
                return notifySuccess(outTradeNo, Constant.PayType.WX.getValue());
            } else {
                log.error("??????????????????");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return setXml(Constant.SUCCESS, "OK");
    }

    /**
     * ??????????????????????????????
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
            return RestResponse.error("??????????????????");
        }
        if (!loginUser.getId().equals(orderInfo.getUserId())) {
            return RestResponse.error("???????????????");
        }

        if (orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            return RestResponse.error("??????????????????????????????????????????");
        }
        MallUserEntity malluserentity = userService.getById(orderInfo.getUserId());
        // ??????????????????
        if (malluserentity.getBalance() == null || malluserentity.getBalance().doubleValue() < orderInfo.getActualPrice().doubleValue()) {
            return RestResponse.error(300, "?????????????????????");
        } else {
            MallAccountLogEntity accountLogEntity = new MallAccountLogEntity();
            accountLogEntity.setLogDesc("????????????");
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
            // ????????????
            notifySuccess(orderInfo.getOrderSn(), Constant.PayType.YE.getValue());

            return RestResponse.success("???????????????");
        }
    }

    // ??????????????????????????????
    private String notifySuccess(String outTradeNo, int payType) {
        //????????????
        log.error("??????" + outTradeNo + "????????????");
        // ????????????
        List<MallOrderEntity> list = orderService.list(new QueryWrapper<MallOrderEntity>().eq("ORDER_SN", outTradeNo).or().eq("PARENT_ID", outTradeNo));
        list.forEach(orderInfo -> {
            // ????????????,????????????
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
                 * ????????????
                 */
                MallShopsEntity shopsEntity = shopsService.getById(orderInfo.getShopsId());
                Map<String, Object> map = new HashMap<>();
                map.put("orderId", orderInfo.getId());
                List<MallOrderGoodsEntity> orderGoodsEntities = orderGoodsService.queryAll(map);
                StringBuilder content = new StringBuilder("<CB>????????????</CB><BR>");
                content.append("?????????").append(orderInfo.getOrderSn()).append("<BR>");
                content.append("??????????????????").append(shopsEntity.getName()).append("???<BR>");
                content.append("--------------------------------<BR>");
                content.append("????????????  ??????  ??????  ??????<BR>");
                for (MallOrderGoodsEntity orderGoodsEntity : orderGoodsEntities) {
                    content.append("--------------------------------<BR>");
                    content.append(orderGoodsEntity.getGoodsName()).append("  ")
                            .append(orderGoodsEntity.getRetailPrice()).append("  ").append(orderGoodsEntity.getNumber()).append("  ")
                            .append(orderGoodsEntity.getRetailPrice().multiply(new BigDecimal(orderGoodsEntity.getNumber()))).append("<BR>");
                }
                content.append("--------------------------------<BR>");
                content.append("?????????").append(orderInfo.getPostscript()).append("<BR>");
                content.append("--------------------------------<BR>");

                content.append("????????????").append(orderInfo.getConsignee()).append("<BR>");
                content.append("???????????????").append(orderInfo.getMobile()).append("<BR>");
                content.append("???????????????").append(orderInfo.getCouponPrice()).append("???<BR>");
                content.append("?????????").append(orderInfo.getOrderPrice()).append("???<BR>");
                content.append("?????????").append(orderInfo.getActualPrice()).append("???<BR>");
                String payTypeText = "????????????";
                if (payType == 2) {
                    payTypeText = "????????????";
                }
                if (payType == 3) {
                    payTypeText = "???????????????";
                }
                if (payType == 4) {
                    payTypeText = "????????????";
                }
                content.append("???????????????").append(payTypeText).append("<BR>");
                content.append("???????????????").append(DateUtils.format(orderInfo.getPayTime(), DateUtils.DATE_TIME_PATTERN)).append("<BR>");
                // ????????????????????????
                content.append("<QR>").append(orderInfo.getOrderSn()).append("</QR>");

                //??????????????????????????????????????????????????????????????????
                SysPrinterEntity printerEntity = printerService.getOne(new QueryWrapper<SysPrinterEntity>().eq("SHOPS_ID", orderInfo.getShopsId()), false);
                if (null != printerEntity) {
                    // ???????????????
                    PrintUtils.printMsg(printerEntity.getSn(), content.toString(), "1");
                    content.append("<RIGHT><BOLD>????????????</BOLD></RIGHT>");
                    content.append("<CUT>");

                    // ?????????????????????
                    PrintUtils.printMsg(StringUtils.isNotBlank(printerEntity.getStubSn()) ? printerEntity.getStubSn() : printerEntity.getSn(), content.toString(), "1");
                }

                // ????????????
                if (Constant.GROUP_ORDER.equals(orderInfo.getOrderType())) {
                    addGroupBuyingRecord(orderInfo);
                }
                // ????????????????????????????????????????????????
                if (Constant.NORMAL_ORDER.equals(orderInfo.getOrderType())) {
                    mallDistOrderService.addDistOrder(orderInfo.getUserId(), orderInfo.getId());
                }

                try {
                    // ??????????????? ???????????????(????????????) ??????100??????????????????
                    BigDecimal totalFee = orderInfo.getActualPrice().divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP);
                    MallUserEntity malluserentity = userService.getById(orderInfo.getUserId());
                    // ?????????????????? ???????????????????????????1???1??????
                    if (null != malluserentity) {
                        malluserentity.setIntegral(malluserentity.getIntegral() + totalFee.intValue());
                        userService.update(malluserentity);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                try {
                    // ????????????
                    if (orderInfo.getFromType().equals(Constant.FromType.MA.getValue())) {
                        sendMsgService.notifyPaySuccess(orderInfo, 1);
                    } else if (orderInfo.getFromType().equals(Constant.FromType.MP.getValue())) {
                        //TODO ??????????????????????????????
                    } else if (orderInfo.getFromType().equals(Constant.FromType.QQ.getValue())) {
                        //TODO QQ?????????????????????
                    } else if (orderInfo.getFromType().equals(Constant.FromType.ALI.getValue())) {
                        //TODO ??????????????????????????????
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
        return setXml(Constant.SUCCESS, "OK");
    }

    /**
     * ??????????????????
     *
     * @param returnCode
     * @param returnMsg
     * @return
     */
    public String setXml(String returnCode, String returnMsg) {
        return "<xml><return_code><![CDATA[" + returnCode + "]]></return_code><return_msg><![CDATA[" + returnMsg + "]]></return_msg></xml>";
    }

    /**
     * ??????????????????????????????
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
        accountLogEntity.setLogDesc("??????????????????");
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
                request.setBody("?????????????????????" + price + "???");
                request.setOutTradeNo(accountLogEntity.getOrderSn());
                //????????????
                request.setTotalFee(BaseWxPayRequest.yuanToFen(price.toString()));
                request.setSpbillCreateIp(spbillCreateIp);
                // ????????????
                request.setNotifyUrl(baseNotifyUrl + "/app/pay/prepayYueNotify");
                // ????????????APP
                request.setTradeType(tradeType);
                request.setOpenid(loginUser.getOpenId());

                //??????????????????????????????????????????????????????????????????
                data = wxPayService.createOrder(request);
            }
            if (ObjectUtils.equals(accountLogEntity.getFromType(), Constant.FromType.QQ.getValue())) {
                //todo QQ????????????
            }
            return RestResponse.success().put("data", data);
        } catch (Exception e) {
            e.printStackTrace();
            return RestResponse.error("????????????,error=" + e.getMessage());
        }
    }

    /**
     * ????????????????????????????????????
     *
     * @param xmlData
     * @return
     */
    public String prepayYueNotify(String xmlData) {
        try {
            WxPayOrderNotifyResult result = wxPayService.parseOrderNotifyResult(xmlData);
            String resultCode = result.getResultCode();
            //????????????
            String outTradeNo = result.getOutTradeNo();
            if (resultCode.equalsIgnoreCase(Constant.FAIL)) {
                log.error("???????????????" + outTradeNo + "????????????");
                return setXml(Constant.SUCCESS, "OK");
            } else if (resultCode.equalsIgnoreCase(Constant.SUCCESS)) {
                log.error("????????????" + outTradeNo + "????????????");
                // ????????????
                MallAccountLogEntity accountLogEntity = accountLogService.getOne(new QueryWrapper<MallAccountLogEntity>().eq("ORDER_SN", outTradeNo));
                // ????????????,????????????
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
                    // TODO ????????????
                } else if (accountLogEntity.getFromType().equals(Constant.FromType.MP.getValue())) {
                    //TODO ??????????????????????????????
                } else if (accountLogEntity.getFromType().equals(Constant.FromType.QQ.getValue())) {
                    //TODO QQ?????????????????????
                }
            } else {
                log.error("????????????????????????");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return setXml(Constant.SUCCESS, "OK");
    }

    /**
     * ???????????????????????????
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
     * ??????????????????????????????
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

            request.setBody(goods.getName() + orderInfo.getActualPrice() + "???");
            request.setOutTradeNo(productId);
            request.setProductId(productId);
            //????????????
            request.setTotalFee(BaseWxPayRequest.yuanToFen(orderInfo.getActualPrice().toString()));
            request.setSpbillCreateIp(spbillCreateIp);
            // ????????????
            request.setNotifyUrl(baseNotifyUrl + "/app/pay/parseOrderNotifyResult");
            // ????????????APP
            request.setTradeType("NATIVE");
            request.setOpenid(result.getOpenid());

            //???????????????????????????????????????????????????????????????????????????????????????"???????????????????????????"
            WxPayUnifiedOrderResult unifiedOrderResult = wxPayService.unifiedOrder(request);

            //??????prepayId
            orderInfo.setPrepayId(unifiedOrderResult.getPrepayId());
            orderService.update(orderInfo);

            XStream xstream = XStreamInitializer.getInstance();
            xstream.autodetectAnnotations(true);

            return unifiedOrderResult;
        } catch (WxPayException e) {
            e.printStackTrace();
        }
        return WxPayNotifyResponse.success("??????");
    }

    /**
     * ??????????????????
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
                //????????????
                log.info("??????????????????" + outTradeNo + "????????????");
                return setXml(Constant.SUCCESS, "OK");
            } else if (resultCode.equalsIgnoreCase(Constant.SUCCESS)) {
                log.info("??????????????????" + outTradeNo + "????????????");
                // ????????????
                MallOrderEntity orderInfo = orderService.getOne(new QueryWrapper<MallOrderEntity>().eq("ORDER_SN", outTradeNo));
                // ????????????,????????????
                if (null == orderInfo || orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
                    return setXml(Constant.SUCCESS, "OK");
                }
                orderInfo.setPayStatus(Constant.PayStatus.YFK.getValue());
                orderInfo.setPayTime(new Date());
                if (orderInfo.getOrderStatus().equals(Constant.OrderStatus.DFK.getValue())) {
                    orderInfo.setOrderStatus(Constant.OrderStatus.YFK.getValue());
                }
                orderService.update(orderInfo);

                // ????????????????????????????????????????????????
                mallDistOrderService.addDistOrder(orderInfo.getUserId(), orderInfo.getId());

            } else {
                log.error("??????????????????????????????");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return setXml(Constant.SUCCESS, "OK");
    }

    /**
     * ????????????????????????
     *
     * @param xmlData
     * @return
     */
    public String parseRefundNotifyResult(String xmlData) {
        try {
            WxPayRefundNotifyResult result = this.wxPayService.parseRefundNotifyResult(xmlData);
            log.info("???????????????result???" + result.toString());
            String returnCode = result.getReturnCode();
            String outTradeNo = result.getReqInfo().getOutTradeNo();
            //???????????? ???
            Integer refundFee = result.getReqInfo().getRefundFee();

            if (returnCode.equalsIgnoreCase(Constant.FAIL)) {
                //????????????
                log.info("??????" + outTradeNo + "????????????");
                return setXml(Constant.SUCCESS, "OK");
            } else if (returnCode.equalsIgnoreCase(Constant.SUCCESS)) {
                log.info("??????" + outTradeNo + "????????????");
                // ????????????
                MallOrderEntity orderInfo = orderService.getOne(new QueryWrapper<MallOrderEntity>().eq("ORDER_SN", outTradeNo));
                // ????????????,????????????
                if (null == orderInfo || orderInfo.getPayStatus().equals(Constant.PayStatus.TK.getValue())) {
                    return setXml(Constant.SUCCESS, "OK");
                }
                orderInfo.setPayStatus(Constant.PayStatus.TK.getValue());
                //??????????????? ??????
                if (orderInfo.getOrderStatus().equals(Constant.OrderStatus.YFH.getValue())) {
                    orderInfo.setOrderStatus(Constant.OrderStatus.THTK.getValue());
                } else {
                    //??????????????? ??????
                    orderInfo.setOrderStatus(Constant.OrderStatus.TK.getValue());
                }
                orderService.update(orderInfo);

                MallUserEntity malluserentity = userService.getById(orderInfo.getUserId());
                malluserentity.setBalance(malluserentity.getBalance().subtract(new BigDecimal(refundFee / 100)));
                userService.update(malluserentity);
            } else {
                log.error("????????????????????????");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return setXml(Constant.SUCCESS, "OK");
    }

    /**
     * ????????????
     *
     * @param orderSaleservice
     * @return
     */
    public boolean applyRefund(MallOrderSaleserviceEntity orderSaleservice) {

        String orderSn = orderSaleservice.getOrderSn();
        MallOrderSaleserviceEntity saleserviceEntity = orderSaleserviceService.getByOrderSn(orderSn);
        if (null != saleserviceEntity) {
            throw new BusinessException("?????????????????????");
        }
        MallOrderEntity orderVo = orderService.getOne(new LambdaQueryWrapper<MallOrderEntity>().eq(MallOrderEntity::getOrderSn, orderSn));
        if (!orderSaleservice.getUserId().equals(orderVo.getUserId())) {
            throw new BusinessException("???????????????");
        }
        // ????????????>??????????????????
        if (orderSaleservice.getAmount().compareTo(orderVo.getActualPrice()) > 0) {
            throw new BusinessException("???????????????????????????????????????");
        }

        // ?????????????????????
        int refundTime = Integer.parseInt(sysConfigService.getValue(Constant.ALLOW_REFUND_TIME, "7"));

        if (new Date().after(DateUtils.addDateDays(orderVo.getPayTime(), refundTime))) {
            throw new BusinessException("????????????????????????");
        }
        orderVo.setOrderStatus(Constant.OrderStatus.SQTK.getValue());
        orderService.update(orderVo);

        orderSaleservice.setStatus(1);
        orderSaleservice.setCreateTime(new Date());
        orderSaleservice.setSaleserviceSn("TK" + StringUtils.generateOrderNumber());
        return orderSaleserviceService.add(orderSaleservice);
    }

    /**
     * ???????????????????????????(app ??????)
     */
    public RestResponse aliPrepay(MallUserEntity loginUser, JSONObject jsonParam) {
        String orderId = jsonParam.getString("orderId");

        MallOrderEntity orderInfo = orderService.getById(orderId);
        if (null == orderInfo) {
            return RestResponse.error("??????????????????");
        }
        if (!loginUser.getId().equals(orderInfo.getUserId())) {
            return RestResponse.error("???????????????");
        }
        if (orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            return RestResponse.error("??????????????????????????????????????????");
        }

        Map<String, Object> orderGoodsParam = new HashMap<>(2);
        orderGoodsParam.put("orderId", orderId);
        //???????????????
        List<MallOrderGoodsEntity> orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        if (null == orderGoods || orderGoods.size() == 0) {
            // ?????????????????????????????????
            orderGoodsParam = new HashMap<>(2);
            orderGoodsParam.put("parentId", orderId);
            orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        }
        StringBuilder body = new StringBuilder();
        if (null != orderGoods && orderGoods.size() > 0) {
            for (MallOrderGoodsEntity goodsVo : orderGoods) {
                if (body.toString().getBytes(StandardCharsets.UTF_8).length < 90) {
                    body.append(goodsVo.getGoodsName()).append("*").append(goodsVo.getNumber()).append("???");
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

            // ??????????????????
            if (orderInfo.getOrderType() == 1) {
                mallDistOrderService.addDistOrder(loginUser.getId(), orderInfo.getId());
            }
            return RestResponse.success().put("data", response.getBody());
        } catch (Exception e) {
            e.printStackTrace();
            return RestResponse.error("????????????,error=" + e.getMessage());
        }
    }

    /**
     * ???????????????????????????(app ??????)
     */
    public RestResponse aliPrepayMa(MallUserEntity loginUser, JSONObject jsonParam) {
        String orderId = jsonParam.getString("orderId");

        MallOrderEntity orderInfo = orderService.getById(orderId);
        if (null == orderInfo) {
            return RestResponse.error("??????????????????");
        }
        if (!loginUser.getId().equals(orderInfo.getUserId())) {
            return RestResponse.error("???????????????");
        }
        if (orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            return RestResponse.error("??????????????????????????????????????????");
        }

        Map<String, Object> orderGoodsParam = new HashMap<>(2);
        orderGoodsParam.put("orderId", orderId);
        //???????????????
        List<MallOrderGoodsEntity> orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        if (null == orderGoods || orderGoods.size() == 0) {
            // ?????????????????????????????????
            orderGoodsParam = new HashMap<>(2);
            orderGoodsParam.put("parentId", orderId);
            orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        }
        StringBuilder body = new StringBuilder();
        if (null != orderGoods && orderGoods.size() > 0) {
            for (MallOrderGoodsEntity goodsVo : orderGoods) {
                if (body.toString().getBytes(StandardCharsets.UTF_8).length < 90) {
                    body.append(goodsVo.getGoodsName()).append("*").append(goodsVo.getNumber()).append("???");
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

            // ??????????????????
            if (orderInfo.getOrderType() == 1) {
                mallDistOrderService.addDistOrder(loginUser.getId(), orderInfo.getId());
            }
            return RestResponse.success().put("data", response.getTradeNo());
        } catch (Exception e) {
            e.printStackTrace();
            return RestResponse.error("????????????,error=" + e.getMessage());
        }
    }

    /**
     * ???????????????????????????(wap web??????)
     */
    public String aliPrepayH5(MallUserEntity loginUser, String orderId, String returnUrl) {
        MallOrderEntity orderInfo = orderService.getById(orderId);
        if (null == orderInfo) {
            throw new BusinessException("??????????????????");
        }
        if (!loginUser.getId().equals(orderInfo.getUserId())) {
            throw new BusinessException("???????????????");
        }
        if (orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            throw new BusinessException("??????????????????????????????????????????");
        }

        Map<String, Object> orderGoodsParam = new HashMap<>(2);
        orderGoodsParam.put("orderId", orderId);
        //???????????????
        List<MallOrderGoodsEntity> orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        if (null == orderGoods || orderGoods.size() == 0) {
            // ?????????????????????????????????
            orderGoodsParam = new HashMap<>(2);
            orderGoodsParam.put("parentId", orderId);
            orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        }
        StringBuilder body = new StringBuilder();
        if (null != orderGoods && orderGoods.size() > 0) {
            for (MallOrderGoodsEntity goodsVo : orderGoods) {
                if (body.toString().getBytes(StandardCharsets.UTF_8).length < 90) {
                    body.append(goodsVo.getGoodsName()).append("*").append(goodsVo.getNumber()).append("???");
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

            // ??????????????????
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
     * ???????????????????????????(wap web??????)
     */
    public String aliPrepayWap(MallUserEntity loginUser, String orderId, String returnUrl) {
        MallOrderEntity orderInfo = orderService.getById(orderId);
        if (null == orderInfo) {
            throw new BusinessException("??????????????????");
        }
        if (!loginUser.getId().equals(orderInfo.getUserId())) {
            throw new BusinessException("???????????????");
        }
        if (orderInfo.getPayStatus().equals(Constant.PayStatus.YFK.getValue())) {
            throw new BusinessException("??????????????????????????????????????????");
        }

        Map<String, Object> orderGoodsParam = new HashMap<>(2);
        orderGoodsParam.put("orderId", orderId);
        //???????????????
        List<MallOrderGoodsEntity> orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        if (null == orderGoods || orderGoods.size() == 0) {
            // ?????????????????????????????????
            orderGoodsParam = new HashMap<>(2);
            orderGoodsParam.put("parentId", orderId);
            orderGoods = orderGoodsService.queryAll(orderGoodsParam);
        }
        StringBuilder body = new StringBuilder();
        if (null != orderGoods && orderGoods.size() > 0) {
            for (MallOrderGoodsEntity goodsVo : orderGoods) {
                if (body.toString().getBytes(StandardCharsets.UTF_8).length < 90) {
                    body.append(goodsVo.getGoodsName()).append("*").append(goodsVo.getNumber()).append("???");
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

            // ??????????????????
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
     * ?????????????????????
     *
     * @param request
     * @return
     */
    public String aliNotify(HttpServletRequest request) {
        try {
            Map<String, String> params = getAllRequestParam(request);
            if (!Factory.Payment.Common().verifyNotify(params)) {
                log.error("????????????");
                return "fail";
            }
            log.info("----------????????????????????????????????????????????????----------");
            log.info(params.toString());
            String trade_status = params.get("trade_status");

            if (trade_status.equals("TRADE_SUCCESS")) {
                String outTradeNo = URLDecoder.decode(params.get("out_trade_no"), "UTF-8");
                log.info("???????????????" + trade_status);
                notifySuccess(outTradeNo, Constant.PayType.ZFB.getValue());
                return "success";
            }
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
        return "fail";
    }

    //?????????????????????
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
     * ??????????????????
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

        // ???ID
        String groupId = order.getGroupId();
        // ????????????
        if (StringUtils.isEmpty(groupId)) {
            buyingRecordEntity.setIsLeader(1);
            buyingRecordEntity.setLeaderId("0");
            buyingRecordEntity.setJoinNumber(1);
            buyingRecordEntity.setStatus(1);
            buyingRecordService.add(buyingRecordEntity);
        } else {
            /**
             * ????????????
             */
            MallGroupBuyingRecordEntity leader = buyingRecordService.getById(groupId);
            if (leader.getStatus() != 1 || leader.getJoinNumber() >= goods.getGroupNumber()) {
                throw new BusinessException("???????????????");
            }

            /**
             * ???????????????
             */
            buyingRecordEntity.setUpdateTime(new Date());
            buyingRecordEntity.setIsLeader(0);
            buyingRecordEntity.setJoinNumber(leader.getJoinNumber());
            buyingRecordEntity.setLeaderId(groupId);
            buyingRecordService.add(buyingRecordEntity);

            // leaderId?????????????????????+1
            buyingRecordService.addJoinNumber(groupId);

            leader.setUpdateTime(new Date());
            leader.setJoinNumber(leader.getJoinNumber() + 1);
            buyingRecordService.updateById(leader);

            // ??????
            if (leader.getJoinNumber().equals(goods.getGroupNumber())) {
                // ????????????????????????
                buyingRecordService.updateStatus(groupId, 2);
            }
        }
    }
}

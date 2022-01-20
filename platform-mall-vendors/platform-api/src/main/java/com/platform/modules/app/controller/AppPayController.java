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
package com.platform.modules.app.controller;

import com.alibaba.fastjson.JSONObject;
import com.platform.annotation.IgnoreAuth;
import com.platform.annotation.LoginUser;
import com.platform.common.utils.RestResponse;
import com.platform.modules.mall.entity.MallUserEntity;
import com.platform.modules.mall.service.PayService;
import io.swagger.annotations.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;

/**
 * <p>
 * 作者: @author Lipengjun <br>
 * 时间: 2017-08-11 08:32<br>
 * 描述: ApiIndexController <br>
 */
@Slf4j
@Api(tags = "ApiPayController|支付管理控制器")
@RestController
@RequestMapping("/app/pay")
public class AppPayController {
    @Autowired
    private PayService payService;

    /**
     * 当面付
     */
    @PostMapping("faceToface")
    @ApiOperation(value = "当面付", notes = "当面付")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "用户token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "orderId", value = "orderId"),
                    @ExampleProperty(mediaType = "tradeType", value = "JSAPI--公众号支付、NATIVE--原生扫码支付、APP--app支付")
            }), required = true, dataType = "string")
    })
    public RestResponse faceToface(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        return payService.faceToface(loginUser, jsonParam);
    }

    /**
     * 当面付回调接口
     *
     * @return
     */
    @ApiOperation(value = "当面付回调接口", notes = "当面付回调接口")
    @IgnoreAuth
    @PostMapping(value = "/faceToFaceNotify", produces = "text/html;charset=UTF-8")
    @Transactional(rollbackFor = Exception.class)
    public String faceToFaceNotify(@RequestBody String xmlData) {
        log.info("----------当面付回调接口回调接口----------");
        log.info(xmlData);
        return payService.faceToFaceNotify(xmlData);
    }

    /**
     * 商品统一下单请求
     */
    @PostMapping("prepay")
    @ApiOperation(value = "商品统一下单请求", notes = "商品统一下单请求")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "用户token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "orderId", value = "orderId"),
                    @ExampleProperty(mediaType = "tradeType", value = "JSAPI--公众号支付、NATIVE--原生扫码支付、APP--app支付")
            }), required = true, dataType = "string")
    })
    public RestResponse payPrepay(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        return payService.payPrepay(loginUser, jsonParam);
    }

    /**
     * 商品统一下单请求回调接口
     *
     * @return
     */
    @ApiOperation(value = "商品统一下单请求回调接口", notes = "商品统一下单请求回调接口")
    @IgnoreAuth
    @PostMapping(value = "/notify", produces = "text/html;charset=UTF-8")
    @Transactional(rollbackFor = Exception.class)
    public String notify(@RequestBody String xmlData) {
        log.info("----------商品统一下单请求回调接口----------");
        log.info(xmlData);
        return payService.notify(xmlData);
    }

    /**
     * 余额充值统一下单请求
     */
    @PostMapping("prepayYue")
    @ApiOperation(value = "余额充值统一下单请求", notes = "余额充值统一下单请求")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "用户token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "price", value = "price"),
                    @ExampleProperty(mediaType = "fromType", value = "用户下单来源类型 1:微信小程序 2:微信公众号 3:app 4:H5 5:支付宝小程序 6:QQ小程序"),
                    @ExampleProperty(mediaType = "tradeType", value = "JSAPI--公众号支付、NATIVE--原生扫码支付、APP--app支付")
            }), required = true, dataType = "string")
    })
    @Transactional(rollbackFor = Exception.class)
    public RestResponse prepayYue(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        return payService.prepayYue(loginUser, jsonParam);
    }

    /**
     * 余额统一下单请求回调接口
     *
     * @return
     */
    @ApiOperation(value = "余额统一下单请求回调接口", notes = "余额统一下单请求回调接口")
    @IgnoreAuth
    @PostMapping(value = "/prepayYueNotify", produces = "text/html;charset=UTF-8")
    @Transactional(rollbackFor = Exception.class)
    public String prepayYueNotify(@RequestBody String xmlData) {
        log.info("----------余额统一下单请求回调接口----------");
        log.info(xmlData);
        return payService.prepayYueNotify(xmlData);
    }

    /**
     * 余额支付（购买商品）
     */
    @PostMapping("buyByYue")
    @ApiOperation(value = "余额支付", notes = "余额支付（购买商品）")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "用户token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "orderId", value = "订单ID"),
                    @ExampleProperty(mediaType = "fromType", value = "用户下单来源类型 1:微信小程序 2:微信公众号 3:app 4:H5 5:支付宝小程序 6:QQ小程序")
            }), required = true, dataType = "string")
    })
    @Transactional(rollbackFor = Exception.class)
    public RestResponse buyByYue(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        return payService.buyByYue(loginUser, jsonParam);
    }

    /**
     * 生成扫码支付二维码
     */
    @IgnoreAuth
    @ApiOperation(value = "生成扫码支付二维码")
    @GetMapping("/generateQrCode")
    public void generateQrCode(HttpServletResponse response) throws Exception {
        byte[] bytes = payService.generateQrCode();
        response.setContentType("image/png");
        OutputStream stream = response.getOutputStream();
        stream.write(bytes);
        stream.flush();
        stream.close();
    }

    /**
     * 扫码支付回调通知处理
     */
    @IgnoreAuth
    @ApiOperation(value = "扫码支付回调通知处理")
    @PostMapping("/parseScanPayNotifyResult")
    public Object parseScanPayNotifyResult(@RequestBody String xmlData) {
        log.info("扫码支付回调数据：" + xmlData);
        return payService.parseScanPayNotifyResult(xmlData);
    }

    /**
     * 扫码支付结果
     */
    @IgnoreAuth
    @ApiOperation(value = "扫码支付结果")
    @PostMapping("/parseOrderNotifyResult")
    public String parseOrderNotifyResult(@RequestBody String xmlData) {
        log.info("扫码支付结果回调数据：" + xmlData);
        return payService.parseOrderNotifyResult(xmlData);
    }

    /**
     * 退款回调通知处理
     */
    @IgnoreAuth
    @ApiOperation(value = "退款回调通知处理")
    @PostMapping("/parseRefundNotifyResult")
    public String parseRefundNotifyResult(@RequestBody String xmlData) {
        log.info("退款回调数据：" + xmlData);
        return payService.parseRefundNotifyResult(xmlData);
    }

    /******************************************************************支付宝支付******************************************************************/

    /**
     * 支付宝统一下单请求(app 支付)
     */
    @PostMapping("aliPrepay")
    @ApiOperation(value = "支付宝统一下单请求(app 支付)", notes = "支付宝统一下单请求(app 支付)")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "用户token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "orderId", value = "orderId")
            }), required = true, dataType = "string")
    })
    public RestResponse aliPrepay(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        return payService.aliPrepay(loginUser, jsonParam);
    }

    /**
     * 支付宝统一下单请求(小程序 支付)
     */
    @PostMapping("aliPrepayMa")
    @ApiOperation(value = "支付宝统一下单请求(小程序 支付)", notes = "支付宝统一下单请求(小程序 支付)")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "用户token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "orderId", value = "orderId")
            }), required = true, dataType = "string")
    })
    public RestResponse aliPrepayMa(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        return payService.aliPrepayMa(loginUser, jsonParam);
    }

    /**
     * 支付宝统一下单请求(pc web支付)
     */
    @GetMapping("aliPrepayH5")
    @ApiOperation(value = "支付宝统一下单请求(pc web支付)", notes = "支付宝统一下单请求(pc web支付)")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "token", value = "用户token"),
                    @ExampleProperty(mediaType = "orderId", value = "orderId"),
                    @ExampleProperty(mediaType = "returnUrl", value = "支付回调url")
            }), required = true, dataType = "string")
    })
    public String aliPrepayH5(@LoginUser MallUserEntity loginUser, String orderId, String returnUrl) {
        return payService.aliPrepayH5(loginUser, orderId, returnUrl);
    }

    /**
     * 支付宝统一下单请求(wap web支付)
     */
    @GetMapping("aliPrepayWap")
    @ApiOperation(value = "支付宝统一下单请求(wap web支付)", notes = "支付宝统一下单请求(wap web支付)")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "token", value = "用户token"),
                    @ExampleProperty(mediaType = "orderId", value = "orderId"),
                    @ExampleProperty(mediaType = "returnUrl", value = "支付回调url")
            }), required = true, dataType = "string")
    })
    public String aliPrepayWap(@LoginUser MallUserEntity loginUser, String orderId, String returnUrl) {
        return payService.aliPrepayWap(loginUser, orderId, returnUrl);
    }

    /**
     * 支付宝统一下单请求回调接口
     *
     * @return
     */
    @ApiOperation(value = "支付宝统一下单请求回调接口", notes = "支付宝统一下单请求回调接口")
    @IgnoreAuth
    @PostMapping(value = "/aliNotify", produces = "text/html;charset=UTF-8")
    @Transactional(rollbackFor = Exception.class)
    public String aliNotify(HttpServletRequest request) {
        return payService.aliNotify(request);
    }
}

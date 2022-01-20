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

import cn.binarywang.wx.miniapp.api.WxMaService;
import cn.binarywang.wx.miniapp.bean.WxMaJscode2SessionResult;
import cn.binarywang.wx.miniapp.bean.WxMaPhoneNumberInfo;
import cn.binarywang.wx.miniapp.bean.WxMaUserInfo;
import com.alibaba.fastjson.JSONObject;
import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.request.AlipaySystemOauthTokenRequest;
import com.alipay.api.request.AlipayUserInfoShareRequest;
import com.alipay.api.response.AlipaySystemOauthTokenResponse;
import com.alipay.api.response.AlipayUserInfoShareResponse;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.google.common.base.Joiner;
import com.platform.annotation.IgnoreAuth;
import com.platform.common.constant.RedisKeyConst;
import com.platform.common.exception.BusinessException;
import com.platform.common.utils.*;
import com.platform.common.validator.AbstractAssert;
import com.platform.modules.app.entity.AppleUserInfo;
import com.platform.modules.app.entity.FullUserInfo;
import com.platform.modules.mall.entity.MallUserEntity;
import com.platform.modules.mall.service.MallUserService;
import com.platform.utils.JwtUtils;
import io.swagger.annotations.*;
import lombok.extern.slf4j.Slf4j;
import me.chanjar.weixin.common.bean.WxJsapiSignature;
import me.chanjar.weixin.common.bean.WxOAuth2UserInfo;
import me.chanjar.weixin.common.bean.oauth2.WxOAuth2AccessToken;
import me.chanjar.weixin.common.error.WxErrorException;
import me.chanjar.weixin.mp.api.WxMpService;
import me.chanjar.weixin.mp.bean.result.WxMpUser;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * APP登录授权
 *
 * @author 李鹏军
 */
@Slf4j
@RestController
@RequestMapping("/app/auth")
@Api(tags = "AppLoginController|APP登录接口")
public class AppLoginController extends AppBaseController {
    @Autowired
    private MallUserService userService;
    @Autowired
    private JwtUtils jwtUtils;
    @Autowired
    private WxMaService wxMaService;
    @Autowired
    private WxMpService wxMpService;
    @Autowired
    private JedisUtil jedisUtil;

    @Value("${qq.miniapp.appid}")
    private String appid;

    @Value("${qq.miniapp.secret}")
    private String secret;

    @Value("${bytedance.open.appId}")
    private String ttAppId;

    @Value("${bytedance.open.secret}")
    private String ttSecret;

    @Value("${ali.ma.appId}")
    private String appId;
    @Value("${ali.ma.privateKey}")
    private String privateKey;
    @Value("${ali.ma.pubKey}")
    private String pubKey;

    /**
     * 用户注册
     *
     * @return RestResponse
     */
    @IgnoreAuth
    @PostMapping("register")
    @ApiOperation(value = "用户注册", notes = "用户注册")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "nickname", value = "nickname"),
                    @ExampleProperty(mediaType = "headImgUrl", value = "headImgUrl"),
                    @ExampleProperty(mediaType = "mobile", value = "mobile"),
                    @ExampleProperty(mediaType = "password", value = "password"),
                    @ExampleProperty(mediaType = "rePassword", value = "rePassword"),
                    @ExampleProperty(mediaType = "code", value = "code"),
                    @ExampleProperty(mediaType = "gender", value = "gender"),
                    @ExampleProperty(mediaType = "birthday", value = "birthday")
            }), required = true, dataType = "string")
    })
    public RestResponse register(@RequestBody JSONObject jsonObject) {
        String headImgUrl = jsonObject.getString("headImgUrl");
        Integer gender = jsonObject.getInteger("gender");
        Date birthday = jsonObject.getDate("birthday");

        String nickname = jsonObject.getString("nickname");
        AbstractAssert.isBlank(nickname, "用户昵称不能为空");

        String password = jsonObject.getString("password");
        AbstractAssert.isBlank(password, "密码不能为空");

        String rePassword = jsonObject.getString("rePassword");
        AbstractAssert.isBlank(rePassword, "密码不能为空");
        if (!password.equals(rePassword)) {
            throw new BusinessException("两次密码不一致！");
        }

        String code = jsonObject.getString("code");
        AbstractAssert.isBlank(code, "验证码不能为空");

        String mobile = jsonObject.getString("mobile");
        AbstractAssert.isBlank(mobile, "手机号不能为空");
        if (!StringUtils.isMobile(mobile)) {
            return RestResponse.error("请输入正确的手机号");
        }

        MallUserEntity userVo = userService.queryByMobile(mobile);
        if (userVo != null) {
            return RestResponse.error("该手机已注册，请直接登录。");
        }

        String smsCode = jedisUtil.get(RedisKeyConst.PRE_SMS + mobile);
        if (StringUtils.isNullOrEmpty(smsCode)) {
            return RestResponse.error("验证码已失效，请重新获取");
        }
        if (!code.equals(smsCode)) {
            return RestResponse.error("验证码错误");
        }

        //用户注册
        MallUserEntity user = new MallUserEntity();
        user.setHeadImgUrl(headImgUrl);
        user.setNickname(nickname);
        user.setUserName(nickname);
        user.setMobile(mobile);
        user.setPassword(DigestUtils.sha256Hex(password));
        user.setRegisterTime(new Date());
        user.setLastLoginTime(new Date());
        user.setRegisterIp(this.getClientIp());
        user.setLastLoginIp(this.getClientIp());
        user.setIntegral(0);
        user.setUserLevelId("1");
        user.setGender(gender);
        user.setBirthday(birthday);
        userService.add(user);

        //生成token
        String token = jwtUtils.generateToken(user.getId());

        Map<String, Object> map = new HashMap<>(4);
        map.put("token", token);
        map.put("userInfo", user);

        return RestResponse.success(map);
    }

    /**
     * 字节跳动小程序登录
     */
    @IgnoreAuth
    @PostMapping("LoginByTT")
    @ApiOperation(value = "微信小程序登录", notes = "wx.login()每次返回的code只能使用一次")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "code", value = "oxaA11ulr9134oBL9Xscon5at_Gc"),
                    @ExampleProperty(mediaType = "anonymousCode", value = "oxaA11ulr9134oBL9Xscon5at_Gc"),
                    @ExampleProperty(mediaType = "userInfo", value = "wx.login()返回的userInfo信息，JSON格式参数")
            }), required = true, dataType = "string")
    })
    public RestResponse LoginByTT(@RequestBody JSONObject jsonObject) {
        FullUserInfo byteDanceFullUserInfo = null;
        String code = jsonObject.getString("code");
        String anonymousCode = jsonObject.getString("anonymousCode");
        AbstractAssert.isBlank(code, "登录失败：code为空");

        if (null != jsonObject.get("userInfo")) {
            byteDanceFullUserInfo = jsonObject.getObject("userInfo", FullUserInfo.class);
        }
        AbstractAssert.isNull(byteDanceFullUserInfo, "登录失败：userInfo为空");

        try {
            Map<String, String> params = new HashMap<>(8);
            params.put("appid", ttAppId);
            params.put("secret", ttSecret);
            if (StringUtils.isNotBlank(code)) {
                params.put("code", code);
            }
            if (StringUtils.isNotBlank(anonymousCode)) {
                params.put("anonymous_code", anonymousCode);
            }

            String result = wxMaService.get("https://developer.toutiao.com/api/apps/jscode2session", Joiner.on("&").withKeyValueSeparator("=").join(params));
            WxMaJscode2SessionResult session = WxMaJscode2SessionResult.fromJson(result);
            // 用户信息校验
            log.info("》》》TT返回sessionData：" + session.toString());

            // 解密用户信息
            WxMaUserInfo wxMaUserInfo = wxMaService.getUserService().getUserInfo(session.getSessionKey(), byteDanceFullUserInfo.getEncryptedData(), byteDanceFullUserInfo.getIv());

            Date nowTime = new Date();
            MallUserEntity user = userService.selectByOpenId(session.getOpenid());
            if (null == user) {
                user = new MallUserEntity();
                user.setPassword(DigestUtils.sha256Hex(jwtUtils.getDefaultPassword()));
                user.setRegisterTime(nowTime);
                user.setRegisterIp(this.getClientIp());
                user.setIntegral(0);
                user.setUserLevelId("1");
            }
            user.setUserName(wxMaUserInfo.getNickName());
            user.setOpenId(session.getOpenid());
            user.setHeadImgUrl(wxMaUserInfo.getAvatarUrl());
            //性别 0：未知、1：男、2：女
            user.setGender(Integer.parseInt(wxMaUserInfo.getGender()));
            user.setNickname(wxMaUserInfo.getNickName());
            user.setLastLoginIp(this.getClientIp());
            user.setLastLoginTime(nowTime);
            userService.saveOrUpdate(user);

            String token = jwtUtils.generateToken(user.getId());

            if (StringUtils.isNullOrEmpty(token)) {
                log.error("登录失败：token生成异常");
                return RestResponse.error("登录失败");
            }
            return RestResponse.success().put("token", token).put("userInfo", user).put("userId", user.getId());
        } catch (WxErrorException e) {
            log.error("登录失败：" + e.getMessage());
            return RestResponse.error("登录失败");
        }
    }

    /**
     * 用户名密码登录
     *
     * @return RestResponse
     */
    @IgnoreAuth
    @PostMapping("loginByMobile")
    @ApiOperation(value = "手机号密码登录", notes = "根据手机号密码登录")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "mobile", value = "15209831990"),
                    @ExampleProperty(mediaType = "password", value = "admin")
            }), required = true, dataType = "string")
    })
    public RestResponse loginByMobile(@RequestBody JSONObject jsonObject) {
        String mobile = jsonObject.getString("mobile");
        AbstractAssert.isBlank(mobile, "手机号不能为空");

        String password = jsonObject.getString("password");
        AbstractAssert.isBlank(password, "密码不能为空");
        //用户登录
        MallUserEntity user = userService.loginByMobile(mobile, password);

        //生成token
        String token = jwtUtils.generateToken(user.getId());

        Map<String, Object> map = new HashMap<>(4);
        map.put("token", token);
        map.put("openId", user.getOpenId());
        map.put("unionId", user.getUnionId());
        map.put("userInfo", user);
        map.put("expire", jwtUtils.getExpire());

        return RestResponse.success(map);
    }

    /**
     * apple登录
     */
    @IgnoreAuth
    @PostMapping("AppleLogin")
    @ApiOperation(value = "apple登录", notes = "apple登录")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "userInfo", value = "uni.login返回的authResult信息，JSON格式参数")
            }), required = true, dataType = "string")
    })
    public RestResponse AppleLogin(@RequestBody JSONObject jsonObject) {
        AppleUserInfo appleUserInfo = null;

        if (null != jsonObject.get("userInfo")) {
            appleUserInfo = jsonObject.getObject("userInfo", AppleUserInfo.class);
        }
        AbstractAssert.isNull(appleUserInfo, "登录失败：userInfo为空");

        try {
//            //验证identityToken
//            if (!AppleUitl.verify(appleUserInfo.getIdentityToken())) {
//                return RestResponse.error("授权验证失败");
//            }
//            //对identityToken解码
//            JSONObject json = AppleUitl.parserIdentityToken(appleUserInfo.getIdentityToken());
//            if (json == null) {
//                return RestResponse.error("授权解码失败");
//            }
//            log.error(json.toJSONString());
            MallUserEntity user = userService.selectByOpenId(appleUserInfo.getOpenId());
            if (user == null) {
                user = new MallUserEntity();
                user.setHeadImgUrl("/static/images/mall/apple.png");
                user.setRegisterTime(new Date());
                user.setRegisterIp(this.getClientIp());
                user.setIntegral(0);
                user.setUserLevelId("1");
                user.setPassword(DigestUtils.sha256Hex(jwtUtils.getDefaultPassword()));
                user.setMobile(appleUserInfo.getEmail());
                String name;
                if (StringUtils.isNotBlank(appleUserInfo.getFullName().getFamilyName())) {
                    name = appleUserInfo.getFullName().getFamilyName() + appleUserInfo.getFullName().getGivenName();
                } else {
                    name = "Apple用户" + CharUtil.getRandomString(8);
                }
                user.setUserName(name);
                user.setNickname(name);
                user.setOpenId(appleUserInfo.getOpenId());
                //性别 0：未知、1：男、2：女
                user.setGender(0);
            }
            user.setLastLoginIp(this.getClientIp());
            user.setLastLoginTime(new Date());

            userService.saveOrUpdate(user);

            String token = jwtUtils.generateToken(user.getId());

            if (StringUtils.isNullOrEmpty(token)) {
                log.error("登录失败：token生成异常");
                return RestResponse.error("登录失败");
            }
            return RestResponse.success().put("token", token).put("userInfo", user).put("userId", user.getId());
        } catch (Exception e) {
            log.error("登录失败：" + e.getMessage());
            return RestResponse.error("登录失败");
        }
    }

    /**
     * 微信小程序登录
     */
    @IgnoreAuth
    @PostMapping("LoginByMa")
    @ApiOperation(value = "微信小程序登录", notes = "wx.login()每次返回的code只能使用一次")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "code", value = "oxaA11ulr9134oBL9Xscon5at_Gc"),
                    @ExampleProperty(mediaType = "userInfo", value = "wx.login()返回的userInfo信息，JSON格式参数")
            }), required = true, dataType = "string")
    })
    public RestResponse LoginByMa(@RequestBody JSONObject jsonObject) {
        FullUserInfo fullUserInfo = null;
        String code = jsonObject.getString("code");
        AbstractAssert.isBlank(code, "登录失败：code为空");

        if (null != jsonObject.get("userInfo")) {
            fullUserInfo = jsonObject.getObject("userInfo", FullUserInfo.class);
        }
        AbstractAssert.isNull(fullUserInfo, "登录失败：userInfo为空");

        try {
            WxMaJscode2SessionResult session = wxMaService.getUserService().getSessionInfo(code);
            // 用户信息校验
            log.info("》》》微信返回sessionData：" + session.toString());

            if (!wxMaService.getUserService().checkUserInfo(session.getSessionKey(), fullUserInfo.getRawData(), fullUserInfo.getSignature())) {
                log.error("登录失败：数据签名验证失败");
                return RestResponse.error("登录失败");
            }

            // 解密用户信息
            WxMaUserInfo wxMpUser = wxMaService.getUserService().getUserInfo(session.getSessionKey(), fullUserInfo.getEncryptedData(), fullUserInfo.getIv());

            MallUserEntity user = userService.selectByOpenUnionId(session.getUnionid());
            if (user == null) {
                // 如果没有开通关联到同一个开放平台使用openId
                user = userService.selectByOpenId(session.getOpenid());
            }
            if (user == null) {
                user = new MallUserEntity();
                user.setRegisterTime(new Date());
                user.setRegisterIp(this.getClientIp());
                user.setIntegral(0);
                user.setUserLevelId("1");
                user.setPassword(DigestUtils.sha256Hex(jwtUtils.getDefaultPassword()));
            }
            user.setUnionId(session.getUnionid());
            user.setOpenId(session.getOpenid());
            //性别 0：未知、1：男、2：女
            user.setGender(Integer.parseInt(wxMpUser.getGender()));
            user.setUserName(wxMpUser.getNickName());
            user.setNickname(wxMpUser.getNickName());
            user.setHeadImgUrl(wxMpUser.getAvatarUrl());
            user.setLastLoginIp(this.getClientIp());
            user.setLastLoginTime(new Date());
            userService.saveOrUpdate(user);

            String token = jwtUtils.generateToken(user.getId());

            if (StringUtils.isNullOrEmpty(token)) {
                log.error("登录失败：token生成异常");
                return RestResponse.error("登录失败");
            }
            return RestResponse.success().put("token", token).put("userInfo", user).put("userId", user.getId());
        } catch (WxErrorException e) {
            log.error("登录失败：" + e.getMessage());
            return RestResponse.error("登录失败");
        }
    }

    /**
     * 微信小程序手机号授权
     */
    @IgnoreAuth
    @PostMapping("LoginByMaPhone")
    @ApiOperation(value = "微信小程序手机号授权", notes = "wx.login()每次返回的code只能使用一次")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "code", value = "oxaA11ulr9134oBL9Xscon5at_Gc"),
                    @ExampleProperty(mediaType = "userInfo", value = "wx.login()返回的userInfo信息，JSON格式参数")
            }), required = true, dataType = "string")
    })
    public RestResponse LoginByMaPhone(@RequestBody JSONObject jsonObject) {
        FullUserInfo fullUserInfo = null;
        String code = jsonObject.getString("code");
        AbstractAssert.isBlank(code, "手机号授权失败：code为空");
        String userId = jsonObject.getString("userId");
        AbstractAssert.isBlank(userId, "userId为空");

        if (null != jsonObject.get("userInfo")) {
            fullUserInfo = jsonObject.getObject("userInfo", FullUserInfo.class);
        }
        AbstractAssert.isNull(fullUserInfo, "手机号授权失败：userInfo为空");

        try {
            WxMaJscode2SessionResult session = wxMaService.getUserService().getSessionInfo(code);
            // 用户信息校验
            log.info("》》》手机号授权微信返回sessionData：" + session.toString());

            // 解密用户信息
            WxMaPhoneNumberInfo wxMpUser = wxMaService.getUserService().getPhoneNoInfo(session.getSessionKey(), fullUserInfo.getEncryptedData(), fullUserInfo.getIv());

            MallUserEntity user = userService.getById(userId);
            user.setMobile(wxMpUser.getPurePhoneNumber());
            user.setPassword(DigestUtils.sha256Hex(jwtUtils.getDefaultPassword()));
            userService.update(user);
            return RestResponse.success("手机号授权成功");
        } catch (WxErrorException e) {
            log.error("手机号授权失败：" + e.getMessage());
            return RestResponse.error("手机号授权失败");
        }
    }

    /**
     * 微信公众号登录
     *
     * @return RestResponse
     */
    @IgnoreAuth
    @PostMapping("loginByMp")
    @ApiOperation(value = "微信公众号登录", notes = "根据微信code登录，每一个code只能使用一次")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "code", value = "oxaA11ulr9134oBL9Xscon5at_Gc")
            }), required = true, dataType = "string")
    })
    public RestResponse loginByMp(@RequestBody JSONObject jsonObject) {
        String code = jsonObject.getString("code");

        AbstractAssert.isBlank(code, "登录失败：code为空");
        String mpAppId = jsonObject.getString("mpAppId");
        AbstractAssert.isBlank(mpAppId, "登录失败：mpAppId为空");

        if (!wxMpService.switchover(mpAppId)) {
            throw new IllegalArgumentException(String.format("未找到对应appid=[%s]的配置，请核实！", mpAppId));
        }

        Map<String, Object> map = new HashMap<>(8);
        try {
            WxOAuth2AccessToken auth2AccessToken = wxMpService.getOAuth2Service().getAccessToken(code);

            String openId = auth2AccessToken.getOpenId();

            //获取微信用户信息
            WxMpUser wxMpUser = wxMpService.getUserService().userInfo(openId);

            MallUserEntity user = userService.selectByOpenUnionId(wxMpUser.getUnionId());
            if (user == null) {
                // 如果没有开通关联到同一个开放平台使用openId
                user = userService.selectByMpOpenId(wxMpUser.getOpenId());
            }
            if (user == null) {
                user = new MallUserEntity();
                user.setRegisterTime(new Date());
                user.setRegisterIp(this.getClientIp());
                user.setIntegral(0);
                user.setUserLevelId("1");
                user.setPassword(DigestUtils.sha256Hex(jwtUtils.getDefaultPassword()));
            }
            user.setUnionId(wxMpUser.getUnionId());
            user.setMpOpenId(wxMpUser.getOpenId());
            user.setUserName(wxMpUser.getNickname());
            user.setNickname(wxMpUser.getNickname());
            user.setHeadImgUrl(wxMpUser.getHeadImgUrl());
            user.setGender(wxMpUser.getSex());
            user.setLastLoginIp(this.getClientIp());
            user.setLastLoginTime(new Date());
            user.setSubscribe(wxMpUser.getSubscribe() ? 1 : 0);
            userService.saveOrUpdate(user);

            //生成token
            String token = jwtUtils.generateToken(user.getId());

            map.put("token", token);
            map.put("expire", jwtUtils.getExpire());
            map.put("openId", openId);
            map.put("unionId", wxMpUser.getUnionId());
            map.put("userInfo", user);
        } catch (WxErrorException e) {
            log.error("登录失败：" + e.getMessage());
            return RestResponse.error("登录失败");
        }

        return RestResponse.success(map);
    }

    /**
     * APP端微信登录
     */
    @IgnoreAuth
    @PostMapping("AppLoginByWx")
    @ApiOperation(value = "APP端微信登录", notes = "APP端微信登录")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "userInfo", value = "uni.login返回的authResult信息，JSON格式参数")
            }), required = true, dataType = "string")
    })
    public RestResponse AppLoginByWx(@RequestBody JSONObject jsonObject) {
        WxOAuth2AccessToken auth2AccessToken = null;

        if (null != jsonObject.get("userInfo")) {
            auth2AccessToken = jsonObject.getObject("userInfo", WxOAuth2AccessToken.class);
        }
        AbstractAssert.isNull(auth2AccessToken, "登录失败：userInfo为空");

        try {
            //获取微信用户信息
            WxOAuth2UserInfo wxMpUser = wxMpService.getOAuth2Service().getUserInfo(auth2AccessToken, null);

            MallUserEntity user = userService.selectByOpenUnionId(wxMpUser.getUnionId());
            if (user == null) {
                user = new MallUserEntity();
                user.setRegisterTime(new Date());
                user.setRegisterIp(this.getClientIp());
                user.setIntegral(0);
                user.setUserLevelId("1");
                user.setPassword(DigestUtils.sha256Hex(jwtUtils.getDefaultPassword()));
            }
            user.setUnionId(wxMpUser.getUnionId());
            user.setUserName(wxMpUser.getNickname());
            user.setNickname(wxMpUser.getNickname());
            user.setHeadImgUrl(wxMpUser.getHeadImgUrl());
            user.setGender(wxMpUser.getSex());
            user.setLastLoginIp(this.getClientIp());
            user.setLastLoginTime(new Date());
            userService.saveOrUpdate(user);

            String token = jwtUtils.generateToken(user.getId());

            if (StringUtils.isNullOrEmpty(token)) {
                log.error("登录失败：token生成异常");
                return RestResponse.error("登录失败");
            }
            return RestResponse.success().put("token", token).put("userInfo", user).put("userId", user.getId());
        } catch (WxErrorException e) {
            log.error("登录失败：" + e.getMessage());
            return RestResponse.error("登录失败");
        }
    }

    /**
     * 支付宝登录
     */
    @IgnoreAuth
    @ApiOperation(value = "支付宝登录")
    @PostMapping("LoginByAli")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "code", value = "oxaA11ulr9134oBL9Xscon5at_Gc")
            }), required = true, dataType = "string")
    })
    public RestResponse LoginByAli(@RequestBody JSONObject jsonObject) {
        String code = jsonObject.getString("code");

        AbstractAssert.isBlank(code, "登录失败：code为空");

        AlipayClient alipayClient = new DefaultAlipayClient("https://openapi.alipay.com/gateway.do", appId,
                privateKey, "json", "UTF-8", pubKey, "RSA2");
        AlipaySystemOauthTokenRequest request = new AlipaySystemOauthTokenRequest();
        request.setCode(code);
        request.setGrantType("authorization_code");
        try {
            //code 换取token
            AlipaySystemOauthTokenResponse oauthTokenResponse = alipayClient.execute(request);
            String accessToken = oauthTokenResponse.getAccessToken();

            //根据token获取用户头像、昵称等信息
            AlipayUserInfoShareRequest userInfoShareRequest = new AlipayUserInfoShareRequest();
            AlipayUserInfoShareResponse userInfoResponse = alipayClient.execute(userInfoShareRequest, accessToken);
            if (!userInfoResponse.isSuccess()) {
                return RestResponse.error("登录失败：" + userInfoResponse.getSubMsg());
            }
            Date nowTime = new Date();
            MallUserEntity user = userService.getOne(new QueryWrapper<MallUserEntity>().eq("ALI_USER_ID", userInfoResponse.getUserId()));
            if (null == user) {
                user = new MallUserEntity();
                String realName = userInfoResponse.getUserName();
                if (realName == null) {
                    realName = CharUtil.getRandomString(12);
                }
                user.setUserName("支付宝用户：" + realName);
                user.setRegisterTime(nowTime);
                user.setRegisterIp(this.getClientIp());
                user.setIntegral(0);
                user.setPassword(DigestUtils.sha256Hex(jwtUtils.getDefaultPassword()));
            }
            user.setAliUserId(userInfoResponse.getUserId());
            user.setHeadImgUrl(userInfoResponse.getAvatar());
            //性别 0：未知、1：男、2：女
            //F：女性；M：男性
            user.setGender("m".equalsIgnoreCase(userInfoResponse.getGender()) ? 1 : 0);
            user.setNickname(userInfoResponse.getNickName());
            user.setLastLoginIp(this.getClientIp());
            user.setLastLoginTime(nowTime);
            userService.saveOrUpdate(user);

            String token = jwtUtils.generateToken(user.getId());

            AbstractAssert.isBlank(token, "登录失败：token生成异常");

            Map<String, Object> resultObj = new HashMap<>();
            resultObj.put("token", token);
            resultObj.put("userInfo", userInfoResponse);
            resultObj.put("userId", user.getId());
            return RestResponse.success(resultObj);
        } catch (AlipayApiException e) {
            log.error("登录失败：" + e.getMessage());
            return RestResponse.error("登录失败");
        }
    }

    /**
     * QQ小程序登录
     */
    @IgnoreAuth
    @PostMapping("LoginByQQ")
    @ApiOperation(value = "QQ小程序登录", notes = "qq.login()每次返回的code只能使用一次")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "code", value = "oxaA11ulr9134oBL9Xscon5at_Gc"),
                    @ExampleProperty(mediaType = "userInfo", value = "qq.login()返回的userInfo信息，JSON格式参数")
            }), required = true, dataType = "string")
    })
    public RestResponse LoginByQQ(@RequestBody JSONObject jsonObject) {
        FullUserInfo fullUserInfo = null;
        String code = jsonObject.getString("code");
        AbstractAssert.isBlank(code, "登录失败：code为空");

        if (null != jsonObject.get("userInfo")) {
            fullUserInfo = jsonObject.getObject("userInfo", FullUserInfo.class);
        }
        AbstractAssert.isNull(fullUserInfo, "登录失败：userInfo为空");

        try {
            Map<String, String> params = new HashMap<>(8);
            params.put("appid", appid);
            params.put("secret", secret);
            params.put("js_code", code);
            params.put("grant_type", "authorization_code");

            String result = wxMaService.get("https://api.q.qq.com/sns/jscode2session", Joiner.on("&").withKeyValueSeparator("=").join(params));
            WxMaJscode2SessionResult session = WxMaJscode2SessionResult.fromJson(result);
            // 用户信息校验
            log.info("》》》QQ返回sessionData：" + session.toString());

            if (!wxMaService.getUserService().checkUserInfo(session.getSessionKey(), fullUserInfo.getData(), fullUserInfo.getSignature())) {
                log.error("登录失败：数据签名验证失败");
                return RestResponse.error("登录失败");
            }

            // 解密用户信息
            WxMaUserInfo wxMaUserInfo = wxMaService.getUserService().getUserInfo(session.getSessionKey(), fullUserInfo.getEncryptedData(), fullUserInfo.getIv());

            Date nowTime = new Date();
            MallUserEntity user = userService.selectByOpenId(session.getOpenid());
            if (null == user) {
                user = new MallUserEntity();
                user.setPassword(DigestUtils.sha256Hex(jwtUtils.getDefaultPassword()));
                user.setRegisterTime(nowTime);
                user.setRegisterIp(this.getClientIp());
                user.setIntegral(0);
                user.setUserLevelId("1");
            }
            user.setUserName(wxMaUserInfo.getNickName());
            user.setQqOpenId(session.getOpenid());
            user.setHeadImgUrl(wxMaUserInfo.getAvatarUrl());
            //性别 0：未知、1：男、2：女
            user.setGender(Integer.parseInt(wxMaUserInfo.getGender()));
            user.setNickname(wxMaUserInfo.getNickName());
            user.setLastLoginIp(this.getClientIp());
            user.setLastLoginTime(nowTime);
            userService.saveOrUpdate(user);

            String token = jwtUtils.generateToken(user.getId());

            if (null == wxMaUserInfo || StringUtils.isNullOrEmpty(token)) {
                log.error("登录失败：token生成异常");
                return RestResponse.error("登录失败");
            }
            return RestResponse.success().put("token", token).put("userInfo", user).put("userId", user.getId());
        } catch (WxErrorException e) {
            log.error("登录失败：" + e.getMessage());
            return RestResponse.error("登录失败");
        }
    }

    /**
     * 根据openId换取登录token，方便本地开发调试
     *
     * @return RestResponse
     */
    @IgnoreAuth
    @PostMapping("loginByOpenId")
    @ApiOperation(value = "openId换取登录token", notes = "根据openId换取登录token，方便本地开发调试")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON格式参数", examples = @Example({
                    @ExampleProperty(mediaType = "openId", value = "ok8KW5GEIwAYTa-Z92JfbzxkVNpA")
            }), required = true, dataType = "string")
    })
    public RestResponse loginByOpenId(@RequestBody JSONObject jsonObject) {
        String openId = jsonObject.getString("openId");
        MallUserEntity user = userService.selectByOpenId(openId);
        AbstractAssert.isNull(user, "登录失败：用户为空");

        //生成token
        String token = jwtUtils.generateToken(user.getId());
        Map<String, Object> map = new HashMap<>(8);
        map.put("token", token);
        map.put("expire", jwtUtils.getExpire());
        map.put("openId", openId);
        map.put("user", user);

        return RestResponse.success(map);
    }

    /**
     * 创建调用jsapi时所需要的签名
     *
     * @return RestResponse
     */
    @IgnoreAuth
    @GetMapping("/createJsapiSignature/{appid}")
    @ApiOperation(value = "创建调用jsapi时所需要的签名", notes = "创建调用jsapi时所需要的签名")
    @ApiImplicitParams({
            @ApiImplicitParam(required = true, paramType = "query", name = "url", value = "url", dataType = "string")
    })
    public RestResponse createJsapiSignature(@PathVariable String appid, String url) {
        WxJsapiSignature data = null;
        try {
            data = wxMpService.switchoverTo(appid).createJsapiSignature(url);
        } catch (WxErrorException e) {
            e.printStackTrace();
        }
        Map<String, Object> map = new HashMap<>(8);
        map.put("data", data);

        return RestResponse.success(map);
    }
}

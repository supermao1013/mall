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
 * APP????????????
 *
 * @author ?????????
 */
@Slf4j
@RestController
@RequestMapping("/app/auth")
@Api(tags = "AppLoginController|APP????????????")
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
     * ????????????
     *
     * @return RestResponse
     */
    @IgnoreAuth
    @PostMapping("register")
    @ApiOperation(value = "????????????", notes = "????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON????????????", examples = @Example({
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
        AbstractAssert.isBlank(nickname, "????????????????????????");

        String password = jsonObject.getString("password");
        AbstractAssert.isBlank(password, "??????????????????");

        String rePassword = jsonObject.getString("rePassword");
        AbstractAssert.isBlank(rePassword, "??????????????????");
        if (!password.equals(rePassword)) {
            throw new BusinessException("????????????????????????");
        }

        String code = jsonObject.getString("code");
        AbstractAssert.isBlank(code, "?????????????????????");

        String mobile = jsonObject.getString("mobile");
        AbstractAssert.isBlank(mobile, "?????????????????????");
        if (!StringUtils.isMobile(mobile)) {
            return RestResponse.error("???????????????????????????");
        }

        MallUserEntity userVo = userService.queryByMobile(mobile);
        if (userVo != null) {
            return RestResponse.error("???????????????????????????????????????");
        }

        String smsCode = jedisUtil.get(RedisKeyConst.PRE_SMS + mobile);
        if (StringUtils.isNullOrEmpty(smsCode)) {
            return RestResponse.error("????????????????????????????????????");
        }
        if (!code.equals(smsCode)) {
            return RestResponse.error("???????????????");
        }

        //????????????
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

        //??????token
        String token = jwtUtils.generateToken(user.getId());

        Map<String, Object> map = new HashMap<>(4);
        map.put("token", token);
        map.put("userInfo", user);

        return RestResponse.success(map);
    }

    /**
     * ???????????????????????????
     */
    @IgnoreAuth
    @PostMapping("LoginByTT")
    @ApiOperation(value = "?????????????????????", notes = "wx.login()???????????????code??????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "code", value = "oxaA11ulr9134oBL9Xscon5at_Gc"),
                    @ExampleProperty(mediaType = "anonymousCode", value = "oxaA11ulr9134oBL9Xscon5at_Gc"),
                    @ExampleProperty(mediaType = "userInfo", value = "wx.login()?????????userInfo?????????JSON????????????")
            }), required = true, dataType = "string")
    })
    public RestResponse LoginByTT(@RequestBody JSONObject jsonObject) {
        FullUserInfo byteDanceFullUserInfo = null;
        String code = jsonObject.getString("code");
        String anonymousCode = jsonObject.getString("anonymousCode");
        AbstractAssert.isBlank(code, "???????????????code??????");

        if (null != jsonObject.get("userInfo")) {
            byteDanceFullUserInfo = jsonObject.getObject("userInfo", FullUserInfo.class);
        }
        AbstractAssert.isNull(byteDanceFullUserInfo, "???????????????userInfo??????");

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
            // ??????????????????
            log.info("?????????TT??????sessionData???" + session.toString());

            // ??????????????????
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
            //?????? 0????????????1?????????2??????
            user.setGender(Integer.parseInt(wxMaUserInfo.getGender()));
            user.setNickname(wxMaUserInfo.getNickName());
            user.setLastLoginIp(this.getClientIp());
            user.setLastLoginTime(nowTime);
            userService.saveOrUpdate(user);

            String token = jwtUtils.generateToken(user.getId());

            if (StringUtils.isNullOrEmpty(token)) {
                log.error("???????????????token????????????");
                return RestResponse.error("????????????");
            }
            return RestResponse.success().put("token", token).put("userInfo", user).put("userId", user.getId());
        } catch (WxErrorException e) {
            log.error("???????????????" + e.getMessage());
            return RestResponse.error("????????????");
        }
    }

    /**
     * ?????????????????????
     *
     * @return RestResponse
     */
    @IgnoreAuth
    @PostMapping("loginByMobile")
    @ApiOperation(value = "?????????????????????", notes = "???????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "mobile", value = "15209831990"),
                    @ExampleProperty(mediaType = "password", value = "admin")
            }), required = true, dataType = "string")
    })
    public RestResponse loginByMobile(@RequestBody JSONObject jsonObject) {
        String mobile = jsonObject.getString("mobile");
        AbstractAssert.isBlank(mobile, "?????????????????????");

        String password = jsonObject.getString("password");
        AbstractAssert.isBlank(password, "??????????????????");
        //????????????
        MallUserEntity user = userService.loginByMobile(mobile, password);

        //??????token
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
     * apple??????
     */
    @IgnoreAuth
    @PostMapping("AppleLogin")
    @ApiOperation(value = "apple??????", notes = "apple??????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "userInfo", value = "uni.login?????????authResult?????????JSON????????????")
            }), required = true, dataType = "string")
    })
    public RestResponse AppleLogin(@RequestBody JSONObject jsonObject) {
        AppleUserInfo appleUserInfo = null;

        if (null != jsonObject.get("userInfo")) {
            appleUserInfo = jsonObject.getObject("userInfo", AppleUserInfo.class);
        }
        AbstractAssert.isNull(appleUserInfo, "???????????????userInfo??????");

        try {
//            //??????identityToken
//            if (!AppleUitl.verify(appleUserInfo.getIdentityToken())) {
//                return RestResponse.error("??????????????????");
//            }
//            //???identityToken??????
//            JSONObject json = AppleUitl.parserIdentityToken(appleUserInfo.getIdentityToken());
//            if (json == null) {
//                return RestResponse.error("??????????????????");
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
                    name = "Apple??????" + CharUtil.getRandomString(8);
                }
                user.setUserName(name);
                user.setNickname(name);
                user.setOpenId(appleUserInfo.getOpenId());
                //?????? 0????????????1?????????2??????
                user.setGender(0);
            }
            user.setLastLoginIp(this.getClientIp());
            user.setLastLoginTime(new Date());

            userService.saveOrUpdate(user);

            String token = jwtUtils.generateToken(user.getId());

            if (StringUtils.isNullOrEmpty(token)) {
                log.error("???????????????token????????????");
                return RestResponse.error("????????????");
            }
            return RestResponse.success().put("token", token).put("userInfo", user).put("userId", user.getId());
        } catch (Exception e) {
            log.error("???????????????" + e.getMessage());
            return RestResponse.error("????????????");
        }
    }

    /**
     * ?????????????????????
     */
    @IgnoreAuth
    @PostMapping("LoginByMa")
    @ApiOperation(value = "?????????????????????", notes = "wx.login()???????????????code??????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "code", value = "oxaA11ulr9134oBL9Xscon5at_Gc"),
                    @ExampleProperty(mediaType = "userInfo", value = "wx.login()?????????userInfo?????????JSON????????????")
            }), required = true, dataType = "string")
    })
    public RestResponse LoginByMa(@RequestBody JSONObject jsonObject) {
        FullUserInfo fullUserInfo = null;
        String code = jsonObject.getString("code");
        AbstractAssert.isBlank(code, "???????????????code??????");

        if (null != jsonObject.get("userInfo")) {
            fullUserInfo = jsonObject.getObject("userInfo", FullUserInfo.class);
        }
        AbstractAssert.isNull(fullUserInfo, "???????????????userInfo??????");

        try {
            WxMaJscode2SessionResult session = wxMaService.getUserService().getSessionInfo(code);
            // ??????????????????
            log.info("?????????????????????sessionData???" + session.toString());

            if (!wxMaService.getUserService().checkUserInfo(session.getSessionKey(), fullUserInfo.getRawData(), fullUserInfo.getSignature())) {
                log.error("???????????????????????????????????????");
                return RestResponse.error("????????????");
            }

            // ??????????????????
            WxMaUserInfo wxMpUser = wxMaService.getUserService().getUserInfo(session.getSessionKey(), fullUserInfo.getEncryptedData(), fullUserInfo.getIv());

            MallUserEntity user = userService.selectByOpenUnionId(session.getUnionid());
            if (user == null) {
                // ??????????????????????????????????????????????????????openId
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
            //?????? 0????????????1?????????2??????
            user.setGender(Integer.parseInt(wxMpUser.getGender()));
            user.setUserName(wxMpUser.getNickName());
            user.setNickname(wxMpUser.getNickName());
            user.setHeadImgUrl(wxMpUser.getAvatarUrl());
            user.setLastLoginIp(this.getClientIp());
            user.setLastLoginTime(new Date());
            userService.saveOrUpdate(user);

            String token = jwtUtils.generateToken(user.getId());

            if (StringUtils.isNullOrEmpty(token)) {
                log.error("???????????????token????????????");
                return RestResponse.error("????????????");
            }
            return RestResponse.success().put("token", token).put("userInfo", user).put("userId", user.getId());
        } catch (WxErrorException e) {
            log.error("???????????????" + e.getMessage());
            return RestResponse.error("????????????");
        }
    }

    /**
     * ??????????????????????????????
     */
    @IgnoreAuth
    @PostMapping("LoginByMaPhone")
    @ApiOperation(value = "??????????????????????????????", notes = "wx.login()???????????????code??????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "code", value = "oxaA11ulr9134oBL9Xscon5at_Gc"),
                    @ExampleProperty(mediaType = "userInfo", value = "wx.login()?????????userInfo?????????JSON????????????")
            }), required = true, dataType = "string")
    })
    public RestResponse LoginByMaPhone(@RequestBody JSONObject jsonObject) {
        FullUserInfo fullUserInfo = null;
        String code = jsonObject.getString("code");
        AbstractAssert.isBlank(code, "????????????????????????code??????");
        String userId = jsonObject.getString("userId");
        AbstractAssert.isBlank(userId, "userId??????");

        if (null != jsonObject.get("userInfo")) {
            fullUserInfo = jsonObject.getObject("userInfo", FullUserInfo.class);
        }
        AbstractAssert.isNull(fullUserInfo, "????????????????????????userInfo??????");

        try {
            WxMaJscode2SessionResult session = wxMaService.getUserService().getSessionInfo(code);
            // ??????????????????
            log.info("????????????????????????????????????sessionData???" + session.toString());

            // ??????????????????
            WxMaPhoneNumberInfo wxMpUser = wxMaService.getUserService().getPhoneNoInfo(session.getSessionKey(), fullUserInfo.getEncryptedData(), fullUserInfo.getIv());

            MallUserEntity user = userService.getById(userId);
            user.setMobile(wxMpUser.getPurePhoneNumber());
            user.setPassword(DigestUtils.sha256Hex(jwtUtils.getDefaultPassword()));
            userService.update(user);
            return RestResponse.success("?????????????????????");
        } catch (WxErrorException e) {
            log.error("????????????????????????" + e.getMessage());
            return RestResponse.error("?????????????????????");
        }
    }

    /**
     * ?????????????????????
     *
     * @return RestResponse
     */
    @IgnoreAuth
    @PostMapping("loginByMp")
    @ApiOperation(value = "?????????????????????", notes = "????????????code??????????????????code??????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "code", value = "oxaA11ulr9134oBL9Xscon5at_Gc")
            }), required = true, dataType = "string")
    })
    public RestResponse loginByMp(@RequestBody JSONObject jsonObject) {
        String code = jsonObject.getString("code");

        AbstractAssert.isBlank(code, "???????????????code??????");
        String mpAppId = jsonObject.getString("mpAppId");
        AbstractAssert.isBlank(mpAppId, "???????????????mpAppId??????");

        if (!wxMpService.switchover(mpAppId)) {
            throw new IllegalArgumentException(String.format("???????????????appid=[%s]????????????????????????", mpAppId));
        }

        Map<String, Object> map = new HashMap<>(8);
        try {
            WxOAuth2AccessToken auth2AccessToken = wxMpService.getOAuth2Service().getAccessToken(code);

            String openId = auth2AccessToken.getOpenId();

            //????????????????????????
            WxMpUser wxMpUser = wxMpService.getUserService().userInfo(openId);

            MallUserEntity user = userService.selectByOpenUnionId(wxMpUser.getUnionId());
            if (user == null) {
                // ??????????????????????????????????????????????????????openId
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

            //??????token
            String token = jwtUtils.generateToken(user.getId());

            map.put("token", token);
            map.put("expire", jwtUtils.getExpire());
            map.put("openId", openId);
            map.put("unionId", wxMpUser.getUnionId());
            map.put("userInfo", user);
        } catch (WxErrorException e) {
            log.error("???????????????" + e.getMessage());
            return RestResponse.error("????????????");
        }

        return RestResponse.success(map);
    }

    /**
     * APP???????????????
     */
    @IgnoreAuth
    @PostMapping("AppLoginByWx")
    @ApiOperation(value = "APP???????????????", notes = "APP???????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "userInfo", value = "uni.login?????????authResult?????????JSON????????????")
            }), required = true, dataType = "string")
    })
    public RestResponse AppLoginByWx(@RequestBody JSONObject jsonObject) {
        WxOAuth2AccessToken auth2AccessToken = null;

        if (null != jsonObject.get("userInfo")) {
            auth2AccessToken = jsonObject.getObject("userInfo", WxOAuth2AccessToken.class);
        }
        AbstractAssert.isNull(auth2AccessToken, "???????????????userInfo??????");

        try {
            //????????????????????????
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
                log.error("???????????????token????????????");
                return RestResponse.error("????????????");
            }
            return RestResponse.success().put("token", token).put("userInfo", user).put("userId", user.getId());
        } catch (WxErrorException e) {
            log.error("???????????????" + e.getMessage());
            return RestResponse.error("????????????");
        }
    }

    /**
     * ???????????????
     */
    @IgnoreAuth
    @ApiOperation(value = "???????????????")
    @PostMapping("LoginByAli")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "code", value = "oxaA11ulr9134oBL9Xscon5at_Gc")
            }), required = true, dataType = "string")
    })
    public RestResponse LoginByAli(@RequestBody JSONObject jsonObject) {
        String code = jsonObject.getString("code");

        AbstractAssert.isBlank(code, "???????????????code??????");

        AlipayClient alipayClient = new DefaultAlipayClient("https://openapi.alipay.com/gateway.do", appId,
                privateKey, "json", "UTF-8", pubKey, "RSA2");
        AlipaySystemOauthTokenRequest request = new AlipaySystemOauthTokenRequest();
        request.setCode(code);
        request.setGrantType("authorization_code");
        try {
            //code ??????token
            AlipaySystemOauthTokenResponse oauthTokenResponse = alipayClient.execute(request);
            String accessToken = oauthTokenResponse.getAccessToken();

            //??????token????????????????????????????????????
            AlipayUserInfoShareRequest userInfoShareRequest = new AlipayUserInfoShareRequest();
            AlipayUserInfoShareResponse userInfoResponse = alipayClient.execute(userInfoShareRequest, accessToken);
            if (!userInfoResponse.isSuccess()) {
                return RestResponse.error("???????????????" + userInfoResponse.getSubMsg());
            }
            Date nowTime = new Date();
            MallUserEntity user = userService.getOne(new QueryWrapper<MallUserEntity>().eq("ALI_USER_ID", userInfoResponse.getUserId()));
            if (null == user) {
                user = new MallUserEntity();
                String realName = userInfoResponse.getUserName();
                if (realName == null) {
                    realName = CharUtil.getRandomString(12);
                }
                user.setUserName("??????????????????" + realName);
                user.setRegisterTime(nowTime);
                user.setRegisterIp(this.getClientIp());
                user.setIntegral(0);
                user.setPassword(DigestUtils.sha256Hex(jwtUtils.getDefaultPassword()));
            }
            user.setAliUserId(userInfoResponse.getUserId());
            user.setHeadImgUrl(userInfoResponse.getAvatar());
            //?????? 0????????????1?????????2??????
            //F????????????M?????????
            user.setGender("m".equalsIgnoreCase(userInfoResponse.getGender()) ? 1 : 0);
            user.setNickname(userInfoResponse.getNickName());
            user.setLastLoginIp(this.getClientIp());
            user.setLastLoginTime(nowTime);
            userService.saveOrUpdate(user);

            String token = jwtUtils.generateToken(user.getId());

            AbstractAssert.isBlank(token, "???????????????token????????????");

            Map<String, Object> resultObj = new HashMap<>();
            resultObj.put("token", token);
            resultObj.put("userInfo", userInfoResponse);
            resultObj.put("userId", user.getId());
            return RestResponse.success(resultObj);
        } catch (AlipayApiException e) {
            log.error("???????????????" + e.getMessage());
            return RestResponse.error("????????????");
        }
    }

    /**
     * QQ???????????????
     */
    @IgnoreAuth
    @PostMapping("LoginByQQ")
    @ApiOperation(value = "QQ???????????????", notes = "qq.login()???????????????code??????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "code", value = "oxaA11ulr9134oBL9Xscon5at_Gc"),
                    @ExampleProperty(mediaType = "userInfo", value = "qq.login()?????????userInfo?????????JSON????????????")
            }), required = true, dataType = "string")
    })
    public RestResponse LoginByQQ(@RequestBody JSONObject jsonObject) {
        FullUserInfo fullUserInfo = null;
        String code = jsonObject.getString("code");
        AbstractAssert.isBlank(code, "???????????????code??????");

        if (null != jsonObject.get("userInfo")) {
            fullUserInfo = jsonObject.getObject("userInfo", FullUserInfo.class);
        }
        AbstractAssert.isNull(fullUserInfo, "???????????????userInfo??????");

        try {
            Map<String, String> params = new HashMap<>(8);
            params.put("appid", appid);
            params.put("secret", secret);
            params.put("js_code", code);
            params.put("grant_type", "authorization_code");

            String result = wxMaService.get("https://api.q.qq.com/sns/jscode2session", Joiner.on("&").withKeyValueSeparator("=").join(params));
            WxMaJscode2SessionResult session = WxMaJscode2SessionResult.fromJson(result);
            // ??????????????????
            log.info("?????????QQ??????sessionData???" + session.toString());

            if (!wxMaService.getUserService().checkUserInfo(session.getSessionKey(), fullUserInfo.getData(), fullUserInfo.getSignature())) {
                log.error("???????????????????????????????????????");
                return RestResponse.error("????????????");
            }

            // ??????????????????
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
            //?????? 0????????????1?????????2??????
            user.setGender(Integer.parseInt(wxMaUserInfo.getGender()));
            user.setNickname(wxMaUserInfo.getNickName());
            user.setLastLoginIp(this.getClientIp());
            user.setLastLoginTime(nowTime);
            userService.saveOrUpdate(user);

            String token = jwtUtils.generateToken(user.getId());

            if (null == wxMaUserInfo || StringUtils.isNullOrEmpty(token)) {
                log.error("???????????????token????????????");
                return RestResponse.error("????????????");
            }
            return RestResponse.success().put("token", token).put("userInfo", user).put("userId", user.getId());
        } catch (WxErrorException e) {
            log.error("???????????????" + e.getMessage());
            return RestResponse.error("????????????");
        }
    }

    /**
     * ??????openId????????????token???????????????????????????
     *
     * @return RestResponse
     */
    @IgnoreAuth
    @PostMapping("loginByOpenId")
    @ApiOperation(value = "openId????????????token", notes = "??????openId????????????token???????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "body", name = "jsonObject", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "openId", value = "ok8KW5GEIwAYTa-Z92JfbzxkVNpA")
            }), required = true, dataType = "string")
    })
    public RestResponse loginByOpenId(@RequestBody JSONObject jsonObject) {
        String openId = jsonObject.getString("openId");
        MallUserEntity user = userService.selectByOpenId(openId);
        AbstractAssert.isNull(user, "???????????????????????????");

        //??????token
        String token = jwtUtils.generateToken(user.getId());
        Map<String, Object> map = new HashMap<>(8);
        map.put("token", token);
        map.put("expire", jwtUtils.getExpire());
        map.put("openId", openId);
        map.put("user", user);

        return RestResponse.success(map);
    }

    /**
     * ????????????jsapi?????????????????????
     *
     * @return RestResponse
     */
    @IgnoreAuth
    @GetMapping("/createJsapiSignature/{appid}")
    @ApiOperation(value = "????????????jsapi?????????????????????", notes = "????????????jsapi?????????????????????")
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

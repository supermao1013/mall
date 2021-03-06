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
package com.platform.modules.mall.controller;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.github.qcloudsms.SmsSingleSenderResult;
import com.platform.common.annotation.SysLog;
import com.platform.common.utils.*;
import com.platform.common.validator.AbstractAssert;
import com.platform.modules.mall.entity.MallShopsEntity;
import com.platform.modules.mall.entity.MallUserEntity;
import com.platform.modules.mall.service.MallShopsService;
import com.platform.modules.mall.service.MallUserService;
import com.platform.modules.sys.controller.AbstractController;
import com.platform.modules.sys.entity.*;
import com.platform.modules.sys.service.*;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.crypto.hash.Sha256Hash;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.platform.common.utils.Constant.SHOPS_BIND;

/**
 * ??????Controller
 *
 * @author ?????????
 * @since 2019-07-03 13:51:29
 */
@Slf4j
@RestController
@RequestMapping("mall/shops")
public class MallShopsController extends AbstractController {
    @Autowired
    private MallShopsService mallShopsService;
    @Autowired
    private SysUserService sysUserService;
    @Autowired
    private SysUserRoleService sysUserRoleService;
    @Autowired
    private SysSmsLogService sysSmsLogService;
    @Autowired
    private SysConfigService sysConfigService;
    @Autowired
    private SysSmsLogService smsLogService;
    @Autowired
    private MallUserService mallUserService;
    @Autowired
    private JedisUtil jedisUtil;
    /**
     * ???????????????????????????
     */
    private String REGISTER_SHOP = "REGISTER_SHOP_";
    private int REGISTER_SHOP_EXPIRE = 5 * 60;
    @Value("${tx.templateId}")
    private Integer templateId;

    /**
     * ??????????????????
     *
     * @param params ????????????
     * @return RestResponse
     */
    @RequestMapping("/queryAll")
    @RequiresPermissions("mall:shops:list")
    public RestResponse queryAll(@RequestParam Map<String, Object> params) {
        List<MallShopsEntity> list = mallShopsService.queryAll(params);

        return RestResponse.success().put("list", list);
    }

    /**
     * ??????????????????
     *
     * @param params ????????????
     * @return RestResponse
     */
    @GetMapping("/list")
    @RequiresPermissions("mall:shops:list")
    public RestResponse list(@RequestParam Map<String, Object> params) {
        //???????????????????????????????????????DataScope
        params.put("dataScope", getDataScope());
        IPage page = mallShopsService.queryPage(params);

        return RestResponse.success().put("page", page);
    }

    /**
     * ????????????????????????
     *
     * @param id ??????
     * @return RestResponse
     */
    @RequestMapping("/info/{id}")
    @RequiresPermissions("mall:shops:info")
    public RestResponse info(@PathVariable("id") String id) {
        MallShopsEntity mallShops = mallShopsService.getById(id);
        return RestResponse.success().put("shops", mallShops);
    }

    /**
     * ????????????
     *
     * @param mallShops mallShops
     * @return RestResponse
     */
    @SysLog("????????????")
    @RequestMapping("/save")
    @RequiresPermissions("mall:shops:save")
    public RestResponse save(@RequestBody MallShopsEntity mallShops) {
        mallShops.setCreateTime(new Date());
        mallShops.setCreateUserId(getUserId());
        mallShopsService.add(mallShops);

        return RestResponse.success();
    }

    /**
     * ????????????
     *
     * @param mallShops mallShops
     * @return RestResponse
     */
    @SysLog("????????????")
    @RequestMapping("/update")
    @RequiresPermissions("mall:shops:update")
    public RestResponse update(@RequestBody MallShopsEntity mallShops) {

        mallShopsService.update(mallShops);

        return RestResponse.success();
    }

    /**
     * ????????????????????????
     *
     * @param ids ids
     * @return RestResponse
     */
    @SysLog("????????????")
    @RequestMapping("/delete")
    @RequiresPermissions("mall:shops:delete")
    public RestResponse delete(@RequestBody String[] ids) {
        mallShopsService.deleteBatch(ids);

        return RestResponse.success();
    }

    /**
     * ????????????????????????
     *
     * @param params ????????????
     * @return RestResponse
     */
    @GetMapping("/myShop")
    @RequiresPermissions("mall:shops:myShop")
    public RestResponse myShop(@RequestParam Map<String, Object> params) {
        params.put("userId", getUserId());
        IPage page = mallShopsService.queryPage(params);

        return RestResponse.success().put("page", page);
    }

    /**
     * ????????????????????????
     *
     * @param params ????????????
     * @return RestResponse
     */
    @RequestMapping("/queryMyShop")
    @RequiresPermissions("mall:shops:myShop")
    public RestResponse queryMyShop(@RequestParam Map<String, Object> params) {
        String userId = getUserId();
        //???????????????????????????
        if (!Constant.SUPER_ADMIN.equals(userId)) {
            params.put("userId", userId);
        }
        List<MallShopsEntity> list = mallShopsService.queryAll(params);

        return RestResponse.success().put("list", list);
    }

    /**
     * ????????????????????????
     *
     * @param params ????????????
     * @return RestResponse
     */
    @RequestMapping("/getMyShop")
    @RequiresPermissions("mall:shops:myShop")
    public RestResponse getMyShop(@RequestParam Map<String, Object> params) {
        String userId = getUserId();
        //????????????????????????
        if (Constant.SUPER_ADMIN.equals(userId)) {
            return RestResponse.success().put("data", "");
        }
        return RestResponse.success().put("data", getShopsId());
    }

    /**
     * ??????????????????
     *
     * @param mallShops mallShops
     * @return RestResponse
     */
    @SysLog("????????????")
    @RequestMapping("/myUpdate")
    @RequiresPermissions("mall:shops:myUpdate")
    public RestResponse myUpdate(@RequestBody MallShopsEntity mallShops) {

        mallShopsService.myUpdate(mallShops, getUserId());

        return RestResponse.success();
    }

    /**
     * ????????????????????????
     *
     * @param id id
     * @return RestResponse
     */
    @SysLog("????????????????????????")
    @RequestMapping("/createQrCode/{id}")
    public RestResponse createQrCode(@PathVariable("id") String id) {

        mallShopsService.createQrCode(id);

        return RestResponse.success();
    }

    /**
     * ????????????
     *
     * @param mallShops mallShops
     * @return RestResponse
     */
    @SysLog("????????????")
    @RequestMapping("/check")
    @RequiresPermissions("mall:shops:update")
    public RestResponse check(@RequestBody MallShopsEntity mallShops) {
        if (StringUtils.isEmpty(mallShops.getUserId()) && StringUtils.isNotBlank(mallShops.getUserId())) {
            return RestResponse.error("???????????????????????????????????????");
        }
        if (mallShops.getApplyStatus() == 1 && StringUtils.isNotBlank(mallShops.getUserId())) {
            SysUserEntity user = sysUserService.getById(mallShops.getUserId());
            user.setStatus(Constant.SysUserStatus.ENABLE.getValue());
            sysUserService.updateById(user);
        }

        mallShopsService.update(mallShops);

        return RestResponse.success();
    }

    /**
     * ????????????
     *
     * @param shopsEntity ??????
     * @return RestResponse
     */
    @SysLog("????????????")
    @PostMapping("/register")
    public RestResponse register(@RequestBody MallShopsEntity shopsEntity) {
        SysUserEntity user = new SysUserEntity();
        user.setSex(0);
        user.setMobile(shopsEntity.getTelephone());
        user.setCreateTime(new Date());
        user.setRealName(shopsEntity.getApplyer());
        String smsCodeRedis = jedisUtil.get(REGISTER_SHOP + shopsEntity.getTelephone());
        if (null == smsCodeRedis) {
            log.error("?????????????????????????????????redis??????????????????");
            return RestResponse.error("?????????????????????");
        }
        if (!shopsEntity.getSmscode().equals(smsCodeRedis)) {
            log.error("??????????????????????????????????????????????????????");
            return RestResponse.error("?????????????????????");
        }
        // ?????????
        user.setStatus(Constant.SysUserStatus.DISABLE.getValue());
        // ??????????????????
        user.setUserName(user.getMobile());
        String salt = RandomStringUtils.randomAlphanumeric(20);
        user.setSalt(salt);
        user.setPassword(new Sha256Hash(shopsEntity.getPassword(), salt).toHex());
        sysUserService.save(user);
        //
        shopsEntity.setUserId(user.getUserId());
        shopsEntity.setCreateUserId(user.getUserId());
        shopsEntity.setCreateTime(new Date());
        shopsEntity.setApplyStatus(Constant.ShopsStatus.UNCHECK.getValue());
        mallShopsService.add(shopsEntity);
        // ??????????????????????????????
        SysUserRoleEntity userRoleEntity = new SysUserRoleEntity();
        userRoleEntity.setRoleId(Constant.SHOPS_ROLE_ID);
        userRoleEntity.setUserId(user.getUserId());
        sysUserRoleService.save(userRoleEntity);

        return RestResponse.success();
    }

    @PostMapping("/registerShopSendCode")
    public RestResponse registerShopSendCode(@RequestBody JSONObject jsonObject) {
        String phone = jsonObject.getString("phone");
        AbstractAssert.isBlank(phone, "?????????????????????");
        if (!StringUtils.isMobileSimple(phone)) {
            log.error("?????????????????????????????????????????????{}", phone);
            return RestResponse.error("??????????????????");
        }
        SysUserEntity sysUserEntity = sysUserService.queryByMobile(phone);
        if (null != sysUserEntity) {
            log.error("??????????????????????????????????????????{}", phone);
            return RestResponse.error("??????????????????");
        }
        String smsCode = CharUtil.getRandomNum(4);
        log.info("??????????????????????????????{}??????????????????{}", phone, smsCode);


        //???????????????????????????
        SmsConfig config = sysConfigService.getConfigObject(Constant.SMS_CONFIG_KEY, SmsConfig.class);
        if (StringUtils.isNullOrEmpty(config)) {
            return RestResponse.error("??????????????????????????????");
        }
        if (StringUtils.isNullOrEmpty(config.getAppid())) {
            return RestResponse.error("????????????????????????APPID");
        }
        if (StringUtils.isNullOrEmpty(config.getAppkey())) {
            return RestResponse.error("??????????????????APP_KEY");
        }
        if (StringUtils.isNullOrEmpty(config.getSign())) {
            return RestResponse.error("??????????????????????????????");
        }

        // ????????????
        SmsSingleSenderResult result;

        try {
            /**
             * ??????????????????{1}?????????{2}????????????????????????????????????????????????????????????
             */
            result = SmsUtil.crSendSms(config.getAppid(), config.getAppkey(), phone, templateId, new String[]{smsCode, "15"}, config.getSign());

            //????????????????????????????????????redis???????????????5??????
            jedisUtil.set(REGISTER_SHOP + phone, smsCode, REGISTER_SHOP_EXPIRE);
            log.info("????????????????????????{}??????????????????{}", phone, smsCode);
            SysSmsLogEntity smsLogVo = new SysSmsLogEntity();
            smsLogVo.setUserId("0");
            smsLogVo.setTemplateId(templateId);
            smsLogVo.setCode(smsCode);
            smsLogVo.setMobile(phone);
            smsLogVo.setStime(new Date());
            smsLogVo.setSign(config.getSign());
            smsLogVo.setReturnMsg(result.errMsg);

            if (result.result == 0) {
                smsLogVo.setSendStatus(result.result);
                smsLogVo.setSendId(result.sid);
                smsLogVo.setSuccessNum(1);
                smsLogService.save(smsLogVo);
                return RestResponse.success("??????????????????");
            } else {
                smsLogVo.setSuccessNum(0);
                smsLogVo.setSendStatus(1);
                smsLogService.save(smsLogVo);
                return RestResponse.error("??????????????????");
            }
        } catch (Exception e) {
            log.info("??????????????????????????????{}??????????????????{}?????????{}", phone, smsCode, e.getMessage());
            return RestResponse.error("?????????????????????" + e);
        }
    }

    @PostMapping("/bindShops")
    public RestResponse bindShops() {
        String code = CharUtil.getRandomNum(4);
        jedisUtil.set(SHOPS_BIND + getShopsId(), code, 15 * 60);
        MallShopsEntity shopsEntity = mallShopsService.getShopsInfo(getUserId());
        if (StringUtils.isNullOrEmpty(shopsEntity.getQrCodeBind())) {
            mallShopsService.createQrCodeBind(shopsEntity.getId());
        }
        shopsEntity = mallShopsService.getShopsInfo(getUserId());
        MallUserEntity userEntity = null;
        if (StringUtils.isNotBlank(shopsEntity.getWithdrawUserId())) {
            userEntity = mallUserService.getById(shopsEntity.getWithdrawUserId());
        }
        return RestResponse.success().put("bindUrl", shopsEntity.getQrCodeBind()).put("userInfo", userEntity).put("checkCode", code);
    }
}

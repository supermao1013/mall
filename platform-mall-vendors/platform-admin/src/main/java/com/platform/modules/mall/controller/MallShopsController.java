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
 * 店铺Controller
 *
 * @author 李鹏军
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
     * 注册商户发送短信码
     */
    private String REGISTER_SHOP = "REGISTER_SHOP_";
    private int REGISTER_SHOP_EXPIRE = 5 * 60;
    @Value("${tx.templateId}")
    private Integer templateId;

    /**
     * 查看所有列表
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @RequestMapping("/queryAll")
    @RequiresPermissions("mall:shops:list")
    public RestResponse queryAll(@RequestParam Map<String, Object> params) {
        List<MallShopsEntity> list = mallShopsService.queryAll(params);

        return RestResponse.success().put("list", list);
    }

    /**
     * 分页查询店铺
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @GetMapping("/list")
    @RequiresPermissions("mall:shops:list")
    public RestResponse list(@RequestParam Map<String, Object> params) {
        //如需数据权限，在参数中添加DataScope
        params.put("dataScope", getDataScope());
        IPage page = mallShopsService.queryPage(params);

        return RestResponse.success().put("page", page);
    }

    /**
     * 根据主键查询详情
     *
     * @param id 主键
     * @return RestResponse
     */
    @RequestMapping("/info/{id}")
    @RequiresPermissions("mall:shops:info")
    public RestResponse info(@PathVariable("id") String id) {
        MallShopsEntity mallShops = mallShopsService.getById(id);
        return RestResponse.success().put("shops", mallShops);
    }

    /**
     * 新增店铺
     *
     * @param mallShops mallShops
     * @return RestResponse
     */
    @SysLog("新增店铺")
    @RequestMapping("/save")
    @RequiresPermissions("mall:shops:save")
    public RestResponse save(@RequestBody MallShopsEntity mallShops) {
        mallShops.setCreateTime(new Date());
        mallShops.setCreateUserId(getUserId());
        mallShopsService.add(mallShops);

        return RestResponse.success();
    }

    /**
     * 修改店铺
     *
     * @param mallShops mallShops
     * @return RestResponse
     */
    @SysLog("修改店铺")
    @RequestMapping("/update")
    @RequiresPermissions("mall:shops:update")
    public RestResponse update(@RequestBody MallShopsEntity mallShops) {

        mallShopsService.update(mallShops);

        return RestResponse.success();
    }

    /**
     * 根据主键删除店铺
     *
     * @param ids ids
     * @return RestResponse
     */
    @SysLog("删除店铺")
    @RequestMapping("/delete")
    @RequiresPermissions("mall:shops:delete")
    public RestResponse delete(@RequestBody String[] ids) {
        mallShopsService.deleteBatch(ids);

        return RestResponse.success();
    }

    /**
     * 分页查询我的店铺
     *
     * @param params 查询参数
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
     * 查询我的所有店铺
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @RequestMapping("/queryMyShop")
    @RequiresPermissions("mall:shops:myShop")
    public RestResponse queryMyShop(@RequestParam Map<String, Object> params) {
        String userId = getUserId();
        //超级管理员查看所有
        if (!Constant.SUPER_ADMIN.equals(userId)) {
            params.put("userId", userId);
        }
        List<MallShopsEntity> list = mallShopsService.queryAll(params);

        return RestResponse.success().put("list", list);
    }

    /**
     * 查询我的所有店铺
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @RequestMapping("/getMyShop")
    @RequiresPermissions("mall:shops:myShop")
    public RestResponse getMyShop(@RequestParam Map<String, Object> params) {
        String userId = getUserId();
        //超级管理员返回空
        if (Constant.SUPER_ADMIN.equals(userId)) {
            return RestResponse.success().put("data", "");
        }
        return RestResponse.success().put("data", getShopsId());
    }

    /**
     * 修改我的店铺
     *
     * @param mallShops mallShops
     * @return RestResponse
     */
    @SysLog("修改店铺")
    @RequestMapping("/myUpdate")
    @RequiresPermissions("mall:shops:myUpdate")
    public RestResponse myUpdate(@RequestBody MallShopsEntity mallShops) {

        mallShopsService.myUpdate(mallShops, getUserId());

        return RestResponse.success();
    }

    /**
     * 生成店铺小程序码
     *
     * @param id id
     * @return RestResponse
     */
    @SysLog("生成店铺小程序码")
    @RequestMapping("/createQrCode/{id}")
    public RestResponse createQrCode(@PathVariable("id") String id) {

        mallShopsService.createQrCode(id);

        return RestResponse.success();
    }

    /**
     * 审核店铺
     *
     * @param mallShops mallShops
     * @return RestResponse
     */
    @SysLog("审核店铺")
    @RequestMapping("/check")
    @RequiresPermissions("mall:shops:update")
    public RestResponse check(@RequestBody MallShopsEntity mallShops) {
        if (StringUtils.isEmpty(mallShops.getUserId()) && StringUtils.isNotBlank(mallShops.getUserId())) {
            return RestResponse.error("审核失败，当前店铺没有用户");
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
     * 商家注册
     *
     * @param shopsEntity 商户
     * @return RestResponse
     */
    @SysLog("商家注册")
    @PostMapping("/register")
    public RestResponse register(@RequestBody MallShopsEntity shopsEntity) {
        SysUserEntity user = new SysUserEntity();
        user.setSex(0);
        user.setMobile(shopsEntity.getTelephone());
        user.setCreateTime(new Date());
        user.setRealName(shopsEntity.getApplyer());
        String smsCodeRedis = jedisUtil.get(REGISTER_SHOP + shopsEntity.getTelephone());
        if (null == smsCodeRedis) {
            log.error("手机号验证码校验失败：redis无短信校验码");
            return RestResponse.error("短信验证码过期");
        }
        if (!shopsEntity.getSmscode().equals(smsCodeRedis)) {
            log.error("手机号验证码校验失败：短信校验码错误");
            return RestResponse.error("短信校验码错误");
        }
        // 未生效
        user.setStatus(Constant.SysUserStatus.DISABLE.getValue());
        // 账号为手机号
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
        // 增加角色和用户的关系
        SysUserRoleEntity userRoleEntity = new SysUserRoleEntity();
        userRoleEntity.setRoleId(Constant.SHOPS_ROLE_ID);
        userRoleEntity.setUserId(user.getUserId());
        sysUserRoleService.save(userRoleEntity);

        return RestResponse.success();
    }

    @PostMapping("/registerShopSendCode")
    public RestResponse registerShopSendCode(@RequestBody JSONObject jsonObject) {
        String phone = jsonObject.getString("phone");
        AbstractAssert.isBlank(phone, "手机号不能为空");
        if (!StringUtils.isMobileSimple(phone)) {
            log.error("手机号校验失败：手机格式错误，{}", phone);
            return RestResponse.error("手机格式错误");
        }
        SysUserEntity sysUserEntity = sysUserService.queryByMobile(phone);
        if (null != sysUserEntity) {
            log.error("手机号已存在，无法重复注册，{}", phone);
            return RestResponse.error("手机号已存在");
        }
        String smsCode = CharUtil.getRandomNum(4);
        log.info("手机发送短信：手机号{}，短信验证码{}", phone, smsCode);


        //获取云存储配置信息
        SmsConfig config = sysConfigService.getConfigObject(Constant.SMS_CONFIG_KEY, SmsConfig.class);
        if (StringUtils.isNullOrEmpty(config)) {
            return RestResponse.error("请先配置短信平台信息");
        }
        if (StringUtils.isNullOrEmpty(config.getAppid())) {
            return RestResponse.error("请先配置短信平台APPID");
        }
        if (StringUtils.isNullOrEmpty(config.getAppkey())) {
            return RestResponse.error("请先配置短信APP_KEY");
        }
        if (StringUtils.isNullOrEmpty(config.getSign())) {
            return RestResponse.error("请先配置短信平台签名");
        }

        // 发送短信
        SmsSingleSenderResult result;

        try {
            /**
             * 您的验证码是{1}，请于{2}分钟内填写。如非本人操作，请忽略本短信。
             */
            result = SmsUtil.crSendSms(config.getAppid(), config.getAppkey(), phone, templateId, new String[]{smsCode, "15"}, config.getSign());

            //发送成功之后将验证码存入redis，有效期为5分钟
            jedisUtil.set(REGISTER_SHOP + phone, smsCode, REGISTER_SHOP_EXPIRE);
            log.info("短信发送：手机号{}，短信验证码{}", phone, smsCode);
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
                return RestResponse.success("短信发送成功");
            } else {
                smsLogVo.setSuccessNum(0);
                smsLogVo.setSendStatus(1);
                smsLogService.save(smsLogVo);
                return RestResponse.error("短信发送失败");
            }
        } catch (Exception e) {
            log.info("短信发送失败：手机号{}，短信验证码{}，原因{}", phone, smsCode, e.getMessage());
            return RestResponse.error("短信发送失败：" + e);
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

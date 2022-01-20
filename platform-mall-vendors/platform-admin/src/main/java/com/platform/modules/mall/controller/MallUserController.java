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

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.platform.common.annotation.SysLog;
import com.platform.common.utils.Constant;
import com.platform.common.utils.RestResponse;
import com.platform.common.utils.StringUtils;
import com.platform.modules.mall.entity.MallAccountLogEntity;
import com.platform.modules.mall.entity.MallIntegralLogEntity;
import com.platform.modules.mall.entity.MallUserEntity;
import com.platform.modules.mall.service.MallAccountLogService;
import com.platform.modules.mall.service.MallIntegralLogService;
import com.platform.modules.mall.service.MallUserService;
import com.platform.modules.sys.controller.AbstractController;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.*;

/**
 * 会员Controller
 *
 * @author 李鹏军
 * @since 2019-07-01 14:59:40
 */
@RestController
@RequestMapping("mall/user")
public class MallUserController extends AbstractController {
    @Autowired
    private MallUserService mallUserService;
    @Autowired
    private MallAccountLogService accountLogService;
    @Autowired
    private MallIntegralLogService integralLogService;

    /**
     * 管理员给会员充值积分
     *
     * @return
     */
    @SysLog("管理员给会员充值积分")
    @RequestMapping("/modIntegral")
    @RequiresPermissions("mall:user:modIntegral")
    public RestResponse modIntegral(@RequestBody Map<String, String> params) {
        String id = params.get("id");
        Integer integral = Integer.parseInt(params.get("integral"));

        MallUserEntity user = mallUserService.getById(id);
        Integer result = user.getIntegral() + integral;
        if (result <= 0) {
            user.setIntegral(0);
        } else {
            user.setIntegral(result);
        }
        mallUserService.updateById(user);

        MallIntegralLogEntity mallIntegralLogEntity = new MallIntegralLogEntity();
        mallIntegralLogEntity.setUserId(id);
        mallIntegralLogEntity.setType(1);
        mallIntegralLogEntity.setTypeDetail(4);
        mallIntegralLogEntity.setNumber(integral);
        mallIntegralLogEntity.setAddTime(new Date());
        integralLogService.save(mallIntegralLogEntity);
        return RestResponse.success();
    }

    /**
     * 管理员给会员充值余额
     *
     * @return
     */
    @SysLog("管理员给会员充值余额")
    @RequestMapping("/modBalance")
    @RequiresPermissions("mall:user:modBalance")
    public RestResponse modBalance(@RequestBody Map<String, String> params) {
        String id = params.get("id");
        BigDecimal balance = new BigDecimal(params.get("balance"));

        MallUserEntity user = mallUserService.getById(id);
        BigDecimal result = user.getBalance().add(balance);
        if (result.compareTo(BigDecimal.valueOf(0)) < 1) {
            user.setBalance(BigDecimal.valueOf(0));
        } else {
            user.setBalance(result);
        }
        mallUserService.updateById(user);

        MallAccountLogEntity accountLogEntity = new MallAccountLogEntity();
        accountLogEntity.setUserId(id);
        accountLogEntity.setType(1);
        accountLogEntity.setPrice(balance);
        accountLogEntity.setLogDesc("系统发放");
        accountLogEntity.setAddTime(new Date());
        accountLogEntity.setOrderType(Constant.ZERO);
        accountLogEntity.setOrderSn(StringUtils.generateOrderNumber());
        accountLogService.save(accountLogEntity);
        return RestResponse.success();
    }

    /**
     * 查看所有列表
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @RequestMapping("/queryAll")
    public RestResponse queryAll(@RequestParam Map<String, Object> params) {
        List<MallUserEntity> list = mallUserService.queryAll(params);

        return RestResponse.success().put("list", list);
    }

    /**
     * 分页查询会员
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @GetMapping("/list")
    @RequiresPermissions("mall:user:list")
    public RestResponse list(@RequestParam Map<String, Object> params) {
        Page page = mallUserService.queryPage(params);

        return RestResponse.success().put("page", page);
    }

    /**
     * 根据主键查询会员详情
     *
     * @param id 主键
     * @return RestResponse
     */
    @RequestMapping("/info/{id}")
    @RequiresPermissions("mall:user:info")
    public RestResponse info(@PathVariable("id") String id) {
        MallUserEntity mallUser = mallUserService.getById(id);

        return RestResponse.success().put("user", mallUser);
    }

    /**
     * 新增会员
     *
     * @param mallUser mallUser
     * @return RestResponse
     */
    @SysLog("新增会员")
    @RequestMapping("/save")
    @RequiresPermissions("mall:user:save")
    public RestResponse save(@RequestBody MallUserEntity mallUser) {

        mallUserService.add(mallUser);

        return RestResponse.success();
    }

    /**
     * 修改会员
     *
     * @param mallUser mallUser
     * @return RestResponse
     */
    @SysLog("修改会员")
    @RequestMapping("/update")
    @RequiresPermissions("mall:user:update")
    public RestResponse update(@RequestBody MallUserEntity mallUser) {

        mallUserService.update(mallUser);

        return RestResponse.success();
    }

    /**
     * 根据主键删除会员
     *
     * @param ids ids
     * @return RestResponse
     */
    @SysLog("删除会员")
    @RequestMapping("/delete")
    @RequiresPermissions("mall:user:delete")
    public RestResponse delete(@RequestBody String[] ids) {
        mallUserService.deleteBatch(ids);

        return RestResponse.success();
    }

    /**
     * 列表
     */
    @PostMapping("/listByIds")
    @RequiresPermissions("wx:wxuser:list")
    public RestResponse listByIds(@RequestBody String[] openids) {
        Map<String, Object> params = new HashMap<>();
        params.put("openids", Arrays.asList(openids));
        List<MallUserEntity> users = mallUserService.queryAll(params);
        return RestResponse.success().put("users", users);
    }
}

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

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.platform.common.annotation.SysLog;
import com.platform.common.utils.RestResponse;
import com.platform.common.utils.StringUtils;
import com.platform.modules.mall.entity.MallAddressEntity;
import com.platform.modules.mall.entity.MallOrderEntity;
import com.platform.modules.mall.entity.MallShopsEntity;
import com.platform.modules.mall.entity.MallShopsWithdrawEntity;
import com.platform.modules.mall.service.MallShopsService;
import com.platform.modules.mall.service.MallShopsWithdrawService;
import com.platform.modules.sys.controller.AbstractController;
import com.platform.modules.sys.service.SysRoleOrgService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 商家提现Controller
 *
 * @author 李鹏军
 * @date 2020-05-05 08:56:53
 */
@RestController
@RequestMapping("mall/shopswithdraw")
public class MallShopsWithdrawController extends AbstractController {
    @Autowired
    private MallShopsWithdrawService mallShopsWithdrawService;
    private SysRoleOrgService sysRoleOrgService;

    @Autowired
    private MallShopsService mallShopsService;

    /**
     * 查看所有列表
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @RequestMapping("/queryAll")
    @RequiresPermissions("mall:shopswithdraw:list")
    public RestResponse queryAll(@RequestParam Map<String, Object> params) {
        List<MallShopsWithdrawEntity> list = mallShopsWithdrawService.queryAll(params);

        return RestResponse.success().put("list", list);
    }

    /**
     * 分页查询商家提现
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @GetMapping("/list")
    @RequiresPermissions("mall:shopswithdraw:list")
    public RestResponse list(@RequestParam Map<String, Object> params) {
        Page page = mallShopsWithdrawService.queryPage(params);

        return RestResponse.success().put("page", page);
    }

    /**
     * 根据主键查询详情
     *
     * @param id 主键
     * @return RestResponse
     */
    @RequestMapping("/info/{id}")
    @RequiresPermissions("mall:shopswithdraw:info")
    public RestResponse info(@PathVariable("id") String id) {

        MallShopsWithdrawEntity mallShopsWithdraw = mallShopsWithdrawService.selectById(id);

        List<MallOrderEntity> relaOrderList = mallShopsWithdrawService.selectRelaOrderList(mallShopsWithdraw.getId());

        return RestResponse.success().put("shopswithdraw", mallShopsWithdraw).put("relaOrderList", relaOrderList);
    }

    /**
     * 商家提现
     *
     * @param mallShopsWithdraw mallShopsWithdraw
     * @return RestResponse
     */
    @SysLog("商家提现")
    @RequestMapping("/confirmWithdraw")
    @RequiresPermissions("mall:shopswithdraw:check")
    public RestResponse confirmWithdraw(@RequestBody MallShopsWithdrawEntity mallShopsWithdraw) {

        return mallShopsWithdrawService.confirmWithdraw(getUserId(), mallShopsWithdraw.getId(), mallShopsWithdraw.getApprovalRemark());

    }

    /**
     * 修改商家提现
     *
     * @param mallShopsWithdraw mallShopsWithdraw
     * @return RestResponse
     */
    @SysLog("修改商家提现")
    @RequestMapping("/refuseWithdraw")
    @RequiresPermissions("mall:shopswithdraw:check")
    public RestResponse refuseWithdraw(@RequestBody MallShopsWithdrawEntity mallShopsWithdraw) {

        return mallShopsWithdrawService.refuseWithdraw(getUserId(), mallShopsWithdraw.getId(), mallShopsWithdraw.getApprovalRemark());

    }

    /**
     * 根据主键删除商家提现
     *
     * @param ids ids
     * @return RestResponse
     */
    @SysLog("删除商家提现")
    @RequestMapping("/delete")
    @RequiresPermissions("mall:shopswithdraw:delete")
    public RestResponse delete(@RequestBody String[] ids) {
        mallShopsWithdrawService.deleteBatch(ids);

        return RestResponse.success();
    }

    /**
     * 店铺金额
     *
     * @return RestResponse
     */
    @SysLog("店铺提现明细")
    @RequestMapping("/withdrawDetail")
    @RequiresPermissions("mall:shopswithdraw:info")
    public RestResponse withdrawDetail() {
        MallShopsEntity shopsEntity = mallShopsService.getShopsInfo(getUserId());
        if (null == shopsEntity) {
            return RestResponse.error("当前账号没有关联的商铺");
        }
        Map result = new HashMap();
//        // 可以提现
        List<MallOrderEntity> canWithdrawList = mallShopsWithdrawService.selectCanWithdrawList(getShopsId());
        result.put("canWithdrawList", canWithdrawList);
        result.put("shopsEntity", shopsEntity);
        result.put("userEntity", getUser());
        return RestResponse.success().put("data", result);
    }

    /**
     * 店铺提现
     *
     * @return RestResponse
     */
    @SysLog("店铺提现")
    @RequestMapping("/withdraw")
    @RequiresPermissions("mall:shopswithdraw:save")
    public RestResponse withdraw(@RequestBody JSONObject jsonParam) {
        JSONArray orderIds = jsonParam.getJSONArray("orderIds");
        if (CollectionUtils.isEmpty(orderIds)) {
            return RestResponse.error("订单不能为空");
        }
        List<String> orderIdList = JSONObject.parseArray(JSONObject.toJSONString(orderIds), String.class);
        MallShopsEntity shopsEntity = mallShopsService.getById(getShopsId());
        if (StringUtils.isNullOrEmpty(shopsEntity.getWithdrawUserId())) {
            return RestResponse.error("店铺请先绑定微信用户");
        }
        return mallShopsWithdrawService.withdrawApply(getUserId(), getShopsId(), shopsEntity.getWithdrawUserId(), orderIdList);
    }
}

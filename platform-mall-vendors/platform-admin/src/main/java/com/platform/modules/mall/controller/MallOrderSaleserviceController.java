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
import com.platform.common.utils.RestResponse;
import com.platform.modules.sys.controller.AbstractController;
import com.platform.modules.mall.entity.MallOrderSaleserviceEntity;
import com.platform.modules.mall.service.MallOrderSaleserviceService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 申请退款Controller
 *
 * @author 李鹏军
 * @since 2021-04-09 11:33:21
 */
@RestController
@RequestMapping("mall/ordersaleservice")
public class MallOrderSaleserviceController extends AbstractController {
    @Autowired
    private MallOrderSaleserviceService mallOrderSaleserviceService;

    /**
     * 查看所有列表
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @RequestMapping("/queryAll")
    @RequiresPermissions("mall:ordersaleservice:list")
    public RestResponse queryAll(@RequestParam Map<String, Object> params) {
        List<MallOrderSaleserviceEntity> list = mallOrderSaleserviceService.queryAll(params);

        return RestResponse.success().put("list", list);
    }

    /**
     * 分页查询申请退款
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @GetMapping("/list")
    @RequiresPermissions("mall:ordersaleservice:list")
    public RestResponse list(@RequestParam Map<String, Object> params) {
        Page page = mallOrderSaleserviceService.queryPage(params);

        return RestResponse.success().put("page", page);
    }

    /**
     * 根据主键查询详情
     *
     * @param id 主键
     * @return RestResponse
     */
    @RequestMapping("/info/{id}")
    @RequiresPermissions("mall:ordersaleservice:info")
    public RestResponse info(@PathVariable("id") String id) {
        Map<String, Object> params = new HashMap<>(2);
        params.put("id", id);
        List<MallOrderSaleserviceEntity> list = mallOrderSaleserviceService.queryAll(params);

        return RestResponse.success().put("ordersaleservice", list.get(0));
    }

    /**
     * 新增申请退款
     *
     * @param mallOrderSaleservice mallOrderSaleservice
     * @return RestResponse
     */
    @SysLog("新增申请退款")
    @RequestMapping("/save")
    @RequiresPermissions("mall:ordersaleservice:save")
    public RestResponse save(@RequestBody MallOrderSaleserviceEntity mallOrderSaleservice) {

        mallOrderSaleserviceService.add(mallOrderSaleservice);

        return RestResponse.success();
    }

    /**
     * 审核通过退款
     *
     * @param mallOrderSaleservice mallOrderSaleservice
     * @return RestResponse
     */
    @SysLog("审核通过退款")
    @RequestMapping("/adopt")
    @RequiresPermissions("mall:ordersaleservice:update")
    public RestResponse adopt(@RequestBody MallOrderSaleserviceEntity mallOrderSaleservice) {

        mallOrderSaleserviceService.adopt(mallOrderSaleservice, getUserId());

        return RestResponse.success();
    }

    /**
     * 审核拒绝退款
     *
     * @param mallOrderSaleservice mallOrderSaleservice
     * @return RestResponse
     */
    @SysLog("审核拒绝退款")
    @RequestMapping("/refuse")
    @RequiresPermissions("mall:ordersaleservice:update")
    public RestResponse refuse(@RequestBody MallOrderSaleserviceEntity mallOrderSaleservice) {
        //已驳回
        mallOrderSaleservice.setStatus(4);
        mallOrderSaleserviceService.update(mallOrderSaleservice);

        return RestResponse.success();
    }
}

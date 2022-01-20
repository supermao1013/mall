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
import com.platform.modules.mall.entity.MallOrderRefundEntity;
import com.platform.modules.mall.service.MallOrderRefundService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 退款记录Controller
 *
 * @author 李鹏军
 * @since 2021-04-09 11:33:21
 */
@RestController
@RequestMapping("mall/orderrefund")
public class MallOrderRefundController extends AbstractController {
    @Autowired
    private MallOrderRefundService mallOrderRefundService;

    /**
     * 查看所有列表
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @RequestMapping("/queryAll")
    @RequiresPermissions("mall:orderrefund:list")
    public RestResponse queryAll(@RequestParam Map<String, Object> params) {
        List<MallOrderRefundEntity> list = mallOrderRefundService.queryAll(params);

        return RestResponse.success().put("list", list);
    }

    /**
     * 分页查询退款记录
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @GetMapping("/list")
    @RequiresPermissions("mall:orderrefund:list")
    public RestResponse list(@RequestParam Map<String, Object> params) {
        Page page = mallOrderRefundService.queryPage(params);

        return RestResponse.success().put("page", page);
    }

    /**
     * 根据主键查询详情
     *
     * @param id 主键
     * @return RestResponse
     */
    @RequestMapping("/info/{id}")
    @RequiresPermissions("mall:orderrefund:info")
    public RestResponse info(@PathVariable("id") Integer id) {
        MallOrderRefundEntity mallOrderRefund = mallOrderRefundService.getById(id);

        return RestResponse.success().put("orderrefund", mallOrderRefund);
    }

    /**
     * 新增退款记录
     *
     * @param mallOrderRefund mallOrderRefund
     * @return RestResponse
     */
    @SysLog("新增退款记录")
    @RequestMapping("/save")
    @RequiresPermissions("mall:orderrefund:save")
    public RestResponse save(@RequestBody MallOrderRefundEntity mallOrderRefund) {

        mallOrderRefundService.add(mallOrderRefund);

        return RestResponse.success();
    }

    /**
     * 修改退款记录
     *
     * @param mallOrderRefund mallOrderRefund
     * @return RestResponse
     */
    @SysLog("修改退款记录")
    @RequestMapping("/update")
    @RequiresPermissions("mall:orderrefund:update")
    public RestResponse update(@RequestBody MallOrderRefundEntity mallOrderRefund) {

        mallOrderRefundService.update(mallOrderRefund);

        return RestResponse.success();
    }

    /**
     * 根据主键删除退款记录
     *
     * @param ids ids
     * @return RestResponse
     */
    @SysLog("删除退款记录")
    @RequestMapping("/delete")
    @RequiresPermissions("mall:orderrefund:delete")
    public RestResponse delete(@RequestBody Integer[] ids) {
        mallOrderRefundService.deleteBatch(ids);

        return RestResponse.success();
    }
}

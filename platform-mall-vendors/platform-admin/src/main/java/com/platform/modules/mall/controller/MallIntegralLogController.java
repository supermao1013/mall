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
import com.platform.modules.mall.entity.MallIntegralLogEntity;
import com.platform.modules.mall.service.MallIntegralLogService;
import com.platform.modules.sys.controller.AbstractController;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 积分变动记录Controller
 *
 * @author 李鹏军
 * @since 2021-07-27 13:29:35
 */
@RestController
@RequestMapping("mall/integrallog")
public class MallIntegralLogController extends AbstractController {
    @Autowired
    private MallIntegralLogService mallIntegralLogService;

    /**
     * 查看所有列表
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @RequestMapping("/queryAll")
    @RequiresPermissions("mall:integrallog:list")
    public RestResponse queryAll(@RequestParam Map<String, Object> params) {
        List<MallIntegralLogEntity> list = mallIntegralLogService.queryAll(params);

        return RestResponse.success().put("list", list);
    }

    /**
     * 分页查询积分变动记录
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @GetMapping("/list")
    @RequiresPermissions("mall:integrallog:list")
    public RestResponse list(@RequestParam Map<String, Object> params) {
        Page page = mallIntegralLogService.queryPage(params);

        return RestResponse.success().put("page", page);
    }

    /**
     * 根据主键查询详情
     *
     * @param id 主键
     * @return RestResponse
     */
    @RequestMapping("/info/{id}")
    @RequiresPermissions("mall:integrallog:info")
    public RestResponse info(@PathVariable("id") String id) {
        MallIntegralLogEntity mallIntegralLog = mallIntegralLogService.getById(id);

        return RestResponse.success().put("integrallog", mallIntegralLog);
    }

    /**
     * 新增积分变动记录
     *
     * @param mallIntegralLog mallIntegralLog
     * @return RestResponse
     */
    @SysLog("新增积分变动记录")
    @RequestMapping("/save")
    @RequiresPermissions("mall:integrallog:save")
    public RestResponse save(@RequestBody MallIntegralLogEntity mallIntegralLog) {

        mallIntegralLogService.add(mallIntegralLog);

        return RestResponse.success();
    }

    /**
     * 修改积分变动记录
     *
     * @param mallIntegralLog mallIntegralLog
     * @return RestResponse
     */
    @SysLog("修改积分变动记录")
    @RequestMapping("/update")
    @RequiresPermissions("mall:integrallog:update")
    public RestResponse update(@RequestBody MallIntegralLogEntity mallIntegralLog) {

        mallIntegralLogService.update(mallIntegralLog);

        return RestResponse.success();
    }

    /**
     * 根据主键删除积分变动记录
     *
     * @param ids ids
     * @return RestResponse
     */
    @SysLog("删除积分变动记录")
    @RequestMapping("/delete")
    @RequiresPermissions("mall:integrallog:delete")
    public RestResponse delete(@RequestBody String[] ids) {
        mallIntegralLogService.deleteBatch(ids);

        return RestResponse.success();
    }
}

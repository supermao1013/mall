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
import com.platform.common.utils.RestResponse;
import com.platform.modules.mall.entity.MallGroupBuyingRecordEntity;
import com.platform.modules.mall.service.MallGroupBuyingRecordService;
import com.platform.modules.sys.controller.AbstractController;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 商品-拼团记录表Controller
 *
 * @author 李鹏军
 * @since 2021-11-14 22:52:41
 */
@RestController
@RequestMapping("mall/groupbuyingrecord")
public class MallGroupBuyingRecordController extends AbstractController {
    @Autowired
    private MallGroupBuyingRecordService mallGroupBuyingRecordService;

    /**
     * 查看所有列表
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @RequestMapping("/queryAll")
    @RequiresPermissions("mall:groupbuyingrecord:list")
    public RestResponse queryAll(@RequestParam Map<String, Object> params) {
        List<MallGroupBuyingRecordEntity> list = mallGroupBuyingRecordService.queryAll(params);

        return RestResponse.success().put("list", list);
    }

    /**
     * 分页查询商品-拼团记录表
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @GetMapping("/list")
    @RequiresPermissions("mall:groupbuyingrecord:list")
    public RestResponse list(@RequestParam Map<String, Object> params) {
        Page page = mallGroupBuyingRecordService.queryPage(params);

        return RestResponse.success().put("page", page);
    }

    /**
     * 根据主键查询详情
     *
     * @param id 主键
     * @return RestResponse
     */
    @RequestMapping("/info/{id}")
    @RequiresPermissions("mall:groupbuyingrecord:info")
    public RestResponse info(@PathVariable("id") String id) {
        Map<String, Object> params = new HashMap<>(4);
        params.put("groupId", id);
        List<MallGroupBuyingRecordEntity> list = mallGroupBuyingRecordService.queryAll(params);

        return RestResponse.success().put("groupbuyingrecord", list.get(0));
    }
}

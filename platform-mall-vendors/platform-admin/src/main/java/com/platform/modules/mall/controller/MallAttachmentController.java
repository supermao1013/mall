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
import com.platform.modules.mall.entity.MallAttachmentEntity;
import com.platform.modules.mall.service.MallAttachmentService;
import com.platform.modules.sys.controller.AbstractController;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 附件表Controller
 *
 * @author 李鹏军
 * @since 2019-07-03 20:06:09
 */
@RestController
@RequestMapping("mall/attachment")
public class MallAttachmentController extends AbstractController {
    @Autowired
    private MallAttachmentService mallAttachmentService;

    /**
     * 查看所有列表
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @RequestMapping("/queryAll")
    public RestResponse queryAll(@RequestParam Map<String, Object> params) {
        List<MallAttachmentEntity> list = mallAttachmentService.queryAll(params);

        return RestResponse.success().put("list", list);
    }

    /**
     * 分页查询附件表
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @GetMapping("/list")
    @RequiresPermissions("mall:attachment:list")
    public RestResponse list(@RequestParam Map<String, Object> params) {
        Page page = mallAttachmentService.queryPage(params);

        return RestResponse.success().put("page", page);
    }

    /**
     * 根据主键查询详情
     *
     * @param id 主键
     * @return RestResponse
     */
    @RequestMapping("/info/{id}")
    @RequiresPermissions("mall:attachment:info")
    public RestResponse info(@PathVariable("id") String id) {
        MallAttachmentEntity mallAttachment = mallAttachmentService.getById(id);

        return RestResponse.success().put("attachment", mallAttachment);
    }

    /**
     * 新增附件表
     *
     * @param mallAttachment mallAttachment
     * @return RestResponse
     */
    @SysLog("新增附件表")
    @RequestMapping("/save")
    @RequiresPermissions("mall:attachment:save")
    public RestResponse save(@RequestBody MallAttachmentEntity mallAttachment) {

        mallAttachmentService.add(mallAttachment);

        return RestResponse.success();
    }

    /**
     * 修改附件表
     *
     * @param mallAttachment mallAttachment
     * @return RestResponse
     */
    @SysLog("修改附件表")
    @RequestMapping("/update")
    @RequiresPermissions("mall:attachment:update")
    public RestResponse update(@RequestBody MallAttachmentEntity mallAttachment) {

        mallAttachmentService.update(mallAttachment);

        return RestResponse.success();
    }

    /**
     * 根据主键删除附件表
     *
     * @param ids ids
     * @return RestResponse
     */
    @SysLog("删除附件表")
    @RequestMapping("/delete")
    @RequiresPermissions("mall:attachment:delete")
    public RestResponse delete(@RequestBody String[] ids) {
        mallAttachmentService.deleteBatch(ids);

        return RestResponse.success();
    }
}

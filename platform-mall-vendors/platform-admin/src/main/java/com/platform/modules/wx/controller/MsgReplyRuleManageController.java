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
package com.platform.modules.wx.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.platform.common.annotation.SysLog;
import com.platform.common.utils.RestResponse;
import com.platform.modules.wx.entity.MsgReplyRuleEntity;
import com.platform.modules.wx.service.MsgReplyRuleService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.Map;

/**
 * 自动回复规则
 *
 * @author 李鹏军
 * @date 2021-05-06 18:30:15
 */
@RestController
@RequestMapping("/manage/msgReplyRule")
public class MsgReplyRuleManageController {
    @Autowired
    private MsgReplyRuleService msgReplyRuleService;

    /**
     * 列表
     */
    @GetMapping("/list")
    @RequiresPermissions("wx:msgreplyrule:list")
    public RestResponse list(@CookieValue String appid, @RequestParam Map<String, Object> params) {
        params.put("appid", appid);
        IPage page = msgReplyRuleService.queryPage(params);

        return RestResponse.success().put("page", page);
    }

    /**
     * 信息
     */
    @GetMapping("/info/{ruleId}")
    @RequiresPermissions("wx:msgreplyrule:info")
    public RestResponse info(@PathVariable("ruleId") String ruleId) {
        MsgReplyRuleEntity msgReplyRule = msgReplyRuleService.getById(ruleId);

        return RestResponse.success().put("msgReplyRule", msgReplyRule);
    }

    /**
     * 保存
     */
    @SysLog("新增公众号回复规则")
    @PostMapping("/save")
    @RequiresPermissions("wx:msgreplyrule:save")
    public RestResponse save(@RequestBody MsgReplyRuleEntity msgReplyRule) {
        msgReplyRuleService.save(msgReplyRule);

        return RestResponse.success();
    }

    /**
     * 修改
     */
    @SysLog("修改公众号回复规则")
    @PostMapping("/update")
    @RequiresPermissions("wx:msgreplyrule:update")
    public RestResponse update(@RequestBody MsgReplyRuleEntity msgReplyRule) {
        msgReplyRuleService.updateById(msgReplyRule);

        return RestResponse.success();
    }

    /**
     * 删除
     */
    @SysLog("删除公众号回复规则")
    @PostMapping("/delete")
    @RequiresPermissions("wx:msgreplyrule:delete")
    public RestResponse delete(@RequestBody String[] ruleIds) {
        msgReplyRuleService.removeByIds(Arrays.asList(ruleIds));

        return RestResponse.success();
    }
}

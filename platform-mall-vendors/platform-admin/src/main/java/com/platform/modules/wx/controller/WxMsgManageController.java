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
import com.platform.modules.wx.entity.WxMsgEntity;
import com.platform.modules.wx.form.WxMsgReplyForm;
import com.platform.modules.wx.service.MsgReplyService;
import com.platform.modules.wx.service.WxMsgService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.Map;

/**
 * 微信消息
 *
 * @author 李鹏军
 * @date 2021-05-06 18:30:15
 */
@RestController
@RequestMapping("/manage/wxMsg")
public class WxMsgManageController {
    @Autowired
    private WxMsgService wxMsgService;
    @Autowired
    private MsgReplyService msgReplyService;

    /**
     * 列表
     */
    @GetMapping("/list")
    @RequiresPermissions("wx:wxmsg:list")
    public RestResponse list(@CookieValue String appid, @RequestParam Map<String, Object> params) {
        params.put("appid", appid);
        IPage page = wxMsgService.queryPage(params);

        return RestResponse.success().put("page", page);
    }

    /**
     * 信息
     */
    @GetMapping("/info/{id}")
    @RequiresPermissions("wx:wxmsg:info")
    public RestResponse info(@CookieValue String appid, @PathVariable("id") Long id) {
        WxMsgEntity wxMsg = wxMsgService.getById(id);

        return RestResponse.success().put("wxMsg", wxMsg);
    }

    /**
     * 回复
     */
    @SysLog("回复公众号消息")
    @PostMapping("/reply")
    @RequiresPermissions("wx:wxmsg:save")
    public RestResponse reply(@CookieValue String appid, @RequestBody WxMsgReplyForm form) {

        msgReplyService.reply(appid, form.getOpenid(), form.getReplyType(), form.getReplyContent());
        return RestResponse.success();
    }

    /**
     * 删除
     */
    @SysLog("删除众号消息")
    @PostMapping("/delete")
    @RequiresPermissions("wx:wxmsg:delete")
    public RestResponse delete(@CookieValue String appid, @RequestBody Long[] ids) {
        wxMsgService.removeByIds(Arrays.asList(ids));

        return RestResponse.success();
    }
}

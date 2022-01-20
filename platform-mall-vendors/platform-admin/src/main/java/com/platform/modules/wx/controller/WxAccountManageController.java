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

import com.platform.common.annotation.SysLog;
import com.platform.common.utils.RestResponse;
import com.platform.modules.wx.entity.WxAccountEntity;
import com.platform.modules.wx.service.WxAccountService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

/**
 * 公众号账号
 *
 * @author 李鹏军
 * @date 2021-05-06 18:30:15
 */
@RestController
@RequestMapping("/manage/wxAccount")
public class WxAccountManageController {
    @Autowired
    private WxAccountService wxAccountService;

    /**
     * 列表
     */
    @GetMapping("/list")
    @RequiresPermissions("wx:wxaccount:list")
    public RestResponse list() {
        List<WxAccountEntity> list = wxAccountService.list();

        return RestResponse.success().put("list", list);
    }


    /**
     * 信息
     */
    @GetMapping("/info/{appid}")
    @RequiresPermissions("wx:wxaccount:info")
    public RestResponse info(@PathVariable("id") String appid) {
        WxAccountEntity wxAccount = wxAccountService.getById(appid);

        return RestResponse.success().put("wxAccount", wxAccount);
    }

    /**
     * 保存
     */
    @SysLog("新增公众号配置")
    @PostMapping("/save")
    @RequiresPermissions("wx:wxaccount:save")
    public RestResponse save(@RequestBody WxAccountEntity wxAccount) {
        wxAccountService.save(wxAccount);

        return RestResponse.success();
    }

    /**
     * 删除
     */
    @SysLog("删除公众号配置")
    @PostMapping("/delete")
    @RequiresPermissions("wx:wxaccount:delete")
    public RestResponse delete(@RequestBody String[] appids) {
        wxAccountService.removeByIds(Arrays.asList(appids));

        return RestResponse.success();
    }
}

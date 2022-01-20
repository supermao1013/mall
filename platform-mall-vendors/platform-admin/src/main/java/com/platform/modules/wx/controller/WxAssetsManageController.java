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
import com.platform.modules.wx.form.MaterialFileDeleteForm;
import com.platform.modules.wx.service.WxAssetsService;
import me.chanjar.weixin.common.error.WxErrorException;
import me.chanjar.weixin.mp.bean.material.*;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

/**
 * 微信公众号素材管理
 * 参考官方文档：https://developers.weixin.qq.com/doc/offiaccount/Asset_Management/New_temporary_materials.html
 * 参考WxJava开发文档：https://github.com/Wechat-Group/WxJava/wiki/MP_永久素材管理
 *
 * @author 李鹏军
 * @date 2021-05-06 18:30:15
 */
@RestController
@RequestMapping("/manage/wxAssets")
public class WxAssetsManageController {
    @Autowired
    WxAssetsService wxAssetsService;

    /**
     * 获取素材总数
     *
     * @return
     * @throws WxErrorException
     */
    @GetMapping("/materialCount")
    public RestResponse materialCount(@CookieValue String appid) throws WxErrorException {
        WxMpMaterialCountResult res = wxAssetsService.materialCount(appid);
        return RestResponse.success().put(res);
    }

    /**
     * 获取素材总数
     *
     * @return
     * @throws WxErrorException
     */
    @GetMapping("/materialNewsInfo")
    public RestResponse materialNewsInfo(@CookieValue String appid, String mediaId) throws WxErrorException {
        WxMpMaterialNews res = wxAssetsService.materialNewsInfo(appid, mediaId);
        return RestResponse.success().put(res);
    }


    /**
     * 根据类别分页获取非图文素材列表
     *
     * @param type
     * @param page
     * @return
     * @throws WxErrorException
     */
    @GetMapping("/materialFileBatchGet")
    @RequiresPermissions("wx:wxassets:list")
    public RestResponse materialFileBatchGet(@CookieValue String appid, @RequestParam(defaultValue = "image") String type,
                                             @RequestParam(defaultValue = "1") int page) throws WxErrorException {
        WxMpMaterialFileBatchGetResult res = wxAssetsService.materialFileBatchGet(appid, type, page);
        return RestResponse.success().put(res);
    }

    /**
     * 分页获取图文素材列表
     *
     * @param page
     * @return
     * @throws WxErrorException
     */
    @GetMapping("/materialNewsBatchGet")
    @RequiresPermissions("wx:wxassets:list")
    public RestResponse materialNewsBatchGet(@CookieValue String appid, @RequestParam(defaultValue = "1") int page) throws WxErrorException {
        WxMpMaterialNewsBatchGetResult res = wxAssetsService.materialNewsBatchGet(appid, page);
        return RestResponse.success().put(res);
    }

    /**
     * 添加图文永久素材
     *
     * @param articles
     * @return
     * @throws WxErrorException
     */
    @SysLog("添加图文永久素材")
    @PostMapping("/materialNewsUpload")
    @RequiresPermissions("wx:wxassets:save")
    public RestResponse materialNewsUpload(@CookieValue String appid, @RequestBody List<WxMpNewsArticle> articles) throws WxErrorException {
        if (articles.isEmpty()) {
            return RestResponse.error("图文列表不得为空");
        }
        WxMpMaterialUploadResult res = wxAssetsService.materialNewsUpload(appid, articles);
        return RestResponse.success().put(res);
    }

    /**
     * 修改图文素材文章
     *
     * @param form
     * @return
     * @throws WxErrorException
     */
    @SysLog("修改图文素材文章")
    @PostMapping("/materialArticleUpdate")
    @RequiresPermissions("wx:wxassets:save")
    public RestResponse materialArticleUpdate(@CookieValue String appid, @RequestBody WxMpMaterialArticleUpdate form) throws WxErrorException {
        if (form.getArticles() == null) {
            return RestResponse.error("文章不得为空");
        }
        wxAssetsService.materialArticleUpdate(appid, form);
        return RestResponse.success();
    }

    /**
     * 添加多媒体永久素材
     *
     * @param file
     * @param fileName
     * @param mediaType
     * @return
     * @throws WxErrorException
     * @throws IOException
     */
    @PostMapping("/materialFileUpload")
    @RequiresPermissions("wx:wxassets:save")
    public RestResponse materialFileUpload(@CookieValue String appid, MultipartFile file, String fileName, String mediaType) throws WxErrorException, IOException {
        if (file == null) {
            return RestResponse.error("文件不得为空");
        }

        WxMpMaterialUploadResult res = wxAssetsService.materialFileUpload(appid, mediaType, fileName, file);
        return RestResponse.success().put(res);
    }

    /**
     * 删除素材
     *
     * @param form
     * @return
     * @throws WxErrorException
     */
    @SysLog("删除素材")
    @PostMapping("/materialDelete")
    @RequiresPermissions("wx:wxassets:delete")
    public RestResponse materialDelete(@CookieValue String appid, @RequestBody MaterialFileDeleteForm form) throws WxErrorException {
        boolean res = wxAssetsService.materialDelete(appid, form.getMediaId());
        return RestResponse.success().put(res);
    }
}

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
package com.platform.modules.app.controller;

import cn.binarywang.wx.miniapp.api.WxMaQrcodeService;
import cn.binarywang.wx.miniapp.bean.WxMaCodeLineColor;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.platform.annotation.IgnoreAuth;
import com.platform.annotation.LoginUser;
import com.platform.common.exception.BusinessException;
import com.platform.common.utils.Base64Util;
import com.platform.common.utils.DateUtils;
import com.platform.common.utils.RestResponse;
import com.platform.common.utils.StringUtils;
import com.platform.modules.mall.entity.*;
import com.platform.modules.mall.service.*;
import com.platform.modules.oss.cloud.UploadFactory;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import me.chanjar.weixin.common.error.WxErrorException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author ?????????
 */
@Slf4j
@RestController
@RequestMapping("/app/goods")
@Api(tags = "AppGoodsController|????????????")
public class AppGoodsController extends AppBaseController {
    @Autowired
    private MallGoodsService goodsService;
    @Autowired
    private MallFootprintService footprintService;
    @Autowired
    private MallUserService userService;
    @Autowired
    private MallIssueService issueService;
    @Autowired
    private MallBrandService brandService;
    @Autowired
    private MallCommentService commentService;
    @Autowired
    private MallCommentPictureService commentPictureService;
    @Autowired
    private MallCollectService collectService;
    @Autowired
    private MallIntegralGoodsService integralGoodsService;
    @Autowired
    private WxMaQrcodeService maQrcodeService;

    /**
     * ???????????????????????????
     */
    @IgnoreAuth
    @GetMapping("/list")
    @ApiOperation(value = "???????????????????????????", notes = "???????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "query", name = "type", value = "?????????IS_HOT??????????????????IS_NEW???????????????", allowableValues = "IS_HOT,IS_NEW", dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "categoryId", value = "??????ID", dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "order", value = "????????????", allowableValues = "RETAIL_PRICE,SALES", dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "sortType", value = "????????????", allowableValues = "ASC,DESC", dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "current", value = "????????????", example = "1", dataType = "int"),
            @ApiImplicitParam(paramType = "query", name = "limit", value = "????????????", example = "10", dataType = "int")
    })
    public RestResponse goodsList(String categoryId, String type, String order, String sortType, @RequestParam(defaultValue = "1") Integer current, @RequestParam(defaultValue = "10") Integer limit) {
        Page<MallGoodsEntity> page = new Page<>(current, limit);

        IPage<MallGoodsEntity> data = goodsService.page(page, new QueryWrapper<MallGoodsEntity>().eq(StringUtils.isNotBlank(categoryId), "CATEGORY_ID", categoryId)
                .eq(StringUtils.isNotBlank(type), type, 1).eq("IS_ON_SALE", 1).orderBy(StringUtils.isNotBlank(order), "ASC".equalsIgnoreCase(sortType), order).orderByDesc("SORT"));


        //???????????????
        List<MallCategoryEntity> filterCategory = getCategoryByData(data.getRecords());

        return RestResponse.success().put("data", data).put("filterCategory", filterCategory);
    }

    /**
     * ????????????
     */
    @IgnoreAuth
    @GetMapping("/detail")
    @ApiOperation(value = "????????????", notes = "??????ID??????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "query", name = "goodsId", value = "??????ID", example = "1", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "userId", value = "??????ID", example = "1", required = true, dataType = "string")
    })
    public RestResponse goodsDetail(String goodsId, String userId) {
        Map<String, Object> resultObj = new HashMap<>();
        MallGoodsEntity info = goodsService.queryById(goodsId);
        //
        MallBrandEntity brand = brandService.getById(info.getBrandId());
        if (null != brand) {
            info.setBrandName(brand.getName());
        }
        if (StringUtils.isNotBlank(userId)) {
            //????????????????????? ???????????????????????????????????????
            MallFootprintEntity footprintEntity = footprintService.getOne(
                    new QueryWrapper<MallFootprintEntity>().eq("USER_ID", userId).eq("GOODS_ID", goodsId), false);
            if (footprintEntity == null) {
                footprintEntity = new MallFootprintEntity();
            }
            footprintEntity.setAddTime(new Date());
            footprintEntity.setUserId(userId);
            footprintEntity.setGoodsId(goodsId);
            footprintService.saveOrUpdate(footprintEntity);
        }
        resultObj.put("info", info);
        return RestResponse.success().put("data", resultObj);
    }

    /**
     * ????????????
     */
    @IgnoreAuth
    @GetMapping("/otherDetail")
    @ApiOperation(value = "????????????", notes = "??????ID??????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "query", name = "goodsId", value = "??????ID", example = "1", required = true, dataType = "string")
    })
    public RestResponse otherDetail(String goodsId, @RequestParam(required = false) String userId) {
        Map<String, Object> resultObj = new HashMap<>();
        List<MallIssueEntity> issue = issueService.list();
        //
        QueryWrapper<MallCommentEntity> commentQuery = new QueryWrapper<MallCommentEntity>().eq("GOODS_ID", goodsId).eq("STATUS", 1);
        Integer commentCount = commentService.count(commentQuery);
        List<MallCommentEntity> hotComment = commentService.list(commentQuery);
        Map<String, Object> commentInfo = new HashMap<>();
        if (null != hotComment && hotComment.size() > 0) {
            MallUserEntity commentUser = userService.getById(hotComment.get(0).getUserId());
            commentInfo.put("content", Base64Util.decode(hotComment.get(0).getContent()));
            commentInfo.put("addTime", DateUtils.format(hotComment.get(0).getAddTime(), DateUtils.DATE_PATTERN));
            commentInfo.put("nickname", commentUser.getNickname());
            commentInfo.put("goodsSpecifitionNameValue", hotComment.get(0).getGoodsSpecifitionNameValue());
            commentInfo.put("headImgUrl", commentUser.getHeadImgUrl());
            List<MallCommentPictureEntity> commentPictureEntities = commentPictureService.list(
                    new QueryWrapper<MallCommentPictureEntity>().eq("comment_id", hotComment.get(0).getId()));
            commentInfo.put("picList", commentPictureEntities);
        }
        Map<String, Object> comment = new HashMap<>(4);
        comment.put("count", commentCount);
        comment.put("data", commentInfo);

        Integer userHasCollect = 0;
        if (!StringUtils.isNullOrEmpty(userId)) {
            //????????????????????????
            userHasCollect = collectService.count(new QueryWrapper<MallCollectEntity>().eq("USER_ID", userId).eq("GOODS_ID", goodsId));
            if (userHasCollect > 0) {
                userHasCollect = 1;
            }
        }
        //
        resultObj.put("userHasCollect", userHasCollect);
        resultObj.put("issue", issue);
        resultObj.put("comment", comment);
        return RestResponse.success().put("data", resultObj);
    }

    /**
     * ????????????
     */
    @IgnoreAuth
    @GetMapping("/count")
    @ApiOperation(value = "????????????", notes = "????????????")
    public RestResponse goodsSum() {
        return RestResponse.success().put("data", goodsService.count(new QueryWrapper<MallGoodsEntity>().eq("IS_ON_SALE", 1)));
    }


    /**
     * ????????????
     */
    @IgnoreAuth
    @GetMapping("newBanner")
    @ApiOperation(value = "????????????banner", notes = "??????????????????????????????")
    public RestResponse newBanner() {
        Map<String, Object> bannerInfo = new HashMap<>(8);
        bannerInfo.put("url", "");
        bannerInfo.put("name", "???????????????????????????????????????");
        bannerInfo.put("imgUrl", "https://platform-wxmall.oss-cn-beijing.aliyuncs.com/grocery/new.png");
        return RestResponse.success().put("data", bannerInfo);
    }

    /**
     * ????????????
     */
    @IgnoreAuth
    @GetMapping("hotBanner")
    @ApiOperation(value = "????????????banner", notes = "??????????????????????????????")
    public RestResponse hotBanner() {
        Map<String, Object> bannerInfo = new HashMap<>();
        bannerInfo.put("url", "");
        bannerInfo.put("name", "????????????????????????");
        bannerInfo.put("imgUrl", "https://platform-wxmall.oss-cn-beijing.aliyuncs.com/grocery/hot.png");
        return RestResponse.success().put("data", bannerInfo);
    }

    /**
     * ????????????????????????
     *
     * @param user
     * @param goodsId
     * @param width
     * @return
     */
    @GetMapping("/getGoodsQrCode")
    @ApiOperation(value = "????????????????????????", notes = "????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "goodsId", value = "??????ID", example = "1", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "width", value = "??????????????????", example = "250", required = true, dataType = "string")
    })
    public RestResponse getGoodsQrCode(@LoginUser MallUserEntity user, String goodsId, @RequestParam(defaultValue = "250") Integer width) {
        String page = "/pages/goods/goods?id=" + goodsId + "&referrer=" + user.getId();
        try {
            byte[] bytes = maQrcodeService.createWxaCodeBytes(page, width, false, new WxMaCodeLineColor("0", "0", "0"), true);

            String url = UploadFactory.build().uploadSuffix(bytes, ".png");

            return RestResponse.success().put("url", url);
        } catch (WxErrorException e) {
            e.printStackTrace();
            throw new BusinessException("???????????????????????????");
        }
    }

    /**
     * ????????????????????????
     *
     * @param user
     * @param goodsId
     * @param width
     * @return
     */
    @GetMapping("/getGroupQrCode")
    @ApiOperation(value = "????????????????????????", notes = "????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "goodsId", value = "??????ID", example = "1", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "width", value = "??????????????????", example = "250", required = true, dataType = "string")
    })
    public RestResponse getGroupQrCode(@LoginUser MallUserEntity user, String goodsId, @RequestParam(defaultValue = "250") Integer width) {
        String page = "/pages/groupDetail/groupDetail?id=" + goodsId + "&referrer=" + user.getId();
        try {
            byte[] bytes = maQrcodeService.createWxaCodeBytes(page, width, false, new WxMaCodeLineColor("0", "0", "0"), true);

            String url = UploadFactory.build().uploadSuffix(bytes, ".png");

            return RestResponse.success().put("url", url);
        } catch (WxErrorException e) {
            e.printStackTrace();
            throw new BusinessException("???????????????????????????");
        }
    }

    /**
     * ??????goodsId??????????????????
     *
     * @param goodsId goodsId
     * @return RestResponse
     */
    @IgnoreAuth
    @GetMapping("/history")
    @ApiOperation(value = "??????goodsId??????????????????", notes = "??????goodsId??????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "query", name = "goodsId", value = "??????ID", example = "1", required = true, dataType = "string")
    })
    public RestResponse history(String goodsId) {

        Map<String, Object> params = new HashMap<>();
        params.put("goodsId", goodsId);

        // ?????????????????????
        params.put("starTime", DateUtils.format(new Date()));

        IPage data = footprintService.queryPage(params);

        return RestResponse.success().put("data", data);
    }

    /**
     * ??????????????????
     */
    @IgnoreAuth
    @GetMapping("/integralGoodsList")
    @ApiOperation(value = "??????????????????", notes = "??????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "query", name = "order", value = "????????????", allowableValues = "RETAIL_PRICE,SALES", dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "sortType", value = "????????????", allowableValues = "ASC,DESC", dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "current", value = "????????????", example = "1", dataType = "int"),
            @ApiImplicitParam(paramType = "query", name = "limit", value = "????????????", example = "10", dataType = "int")
    })
    public RestResponse integralGoodsList(String order, String sortType, @RequestParam(defaultValue = "1") Integer current, @RequestParam(defaultValue = "10") Integer limit) {
        Page<MallIntegralGoodsEntity> page = new Page<>(current, limit);

        IPage<MallIntegralGoodsEntity> data = integralGoodsService.page(page, new QueryWrapper<MallIntegralGoodsEntity>()
                .eq("IS_ON_SALE", 1).orderBy(StringUtils.isNotBlank(order), "ASC".equalsIgnoreCase(sortType), order).orderByDesc("SORT"));

        return RestResponse.success().put("data", data);
    }

    /**
     * ????????????
     */
    @IgnoreAuth
    @GetMapping("/integralGoodsDetail")
    @ApiOperation(value = "??????????????????", notes = "??????ID????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "query", name = "goodsId", value = "??????ID", example = "1", required = true, dataType = "string")
    })
    public RestResponse integralGoodsDetail(String goodsId) {
        MallIntegralGoodsEntity info = integralGoodsService.getById(goodsId);
        return RestResponse.success().put("data", info);
    }
}

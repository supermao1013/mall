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

import cn.binarywang.wx.miniapp.api.WxMaSecCheckService;
import cn.binarywang.wx.miniapp.api.WxMaService;
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.platform.annotation.IgnoreAuth;
import com.platform.annotation.LoginUser;
import com.platform.common.exception.BusinessException;
import com.platform.common.utils.Base64Util;
import com.platform.common.utils.RestResponse;
import com.platform.common.utils.StringUtils;
import com.platform.modules.mall.entity.MallCommentEntity;
import com.platform.modules.mall.entity.MallCommentPictureEntity;
import com.platform.modules.mall.entity.MallUserEntity;
import com.platform.modules.mall.service.MallCommentPictureService;
import com.platform.modules.mall.service.MallCommentService;
import com.platform.modules.mall.service.MallUserService;
import io.swagger.annotations.*;
import me.chanjar.weixin.common.error.WxErrorException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * ??????: @author Lipengjun <br>
 * ??????: 2017-08-11 08:32<br>
 * ??????: ApiIndexController <br>
 */
@Api(tags = "ApiCommentController|???????????????????????????")
@RestController
@RequestMapping("/app/comment")
public class AppCommentController {
    @Autowired
    private MallCommentService commentService;
    @Autowired
    private MallUserService userService;
    @Autowired
    private MallCommentPictureService commentPictureService;
    @Autowired
    private WxMaService maService;

    /**
     * ????????????
     */
    @PostMapping("post")
    @ApiOperation(value = "????????????", notes = "????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "orderId", value = "1"),
                    @ExampleProperty(mediaType = "evalLevel", value = "???????????????int??????"),
                    @ExampleProperty(mediaType = "deliveryLevel", value = "???????????????int??????"),
                    @ExampleProperty(mediaType = "goodsList", value = "json"),
                    @ExampleProperty(mediaType = "type", value = "0")
            }), required = true, dataType = "string")
    })
    @Transactional(rollbackFor = Exception.class)
    @SuppressWarnings("unchecked")
    public RestResponse post(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) throws WxErrorException {
        String orderId = jsonParam.getString("orderId");
        Integer evalLevel = jsonParam.getInteger("evalLevel");
        Integer deliveryLevel = jsonParam.getInteger("deliveryLevel");
        Integer type = jsonParam.getInteger("type");
        List<Map<String, Object>> goodsList = jsonParam.getObject("goodsList", List.class);
        WxMaSecCheckService maSecCheckService = maService.getSecCheckService();

        for (Map<String, Object> goods : goodsList) {
            List<String> pics = (List<String>) goods.get("pics");
            String goodsId = goods.get("goodsId").toString();
            String goodsSpecifitionNameValue = goods.get("goodsSpecifitionNameValue").toString();
            String goodsLevel = goods.getOrDefault("goodsLevel", 5).toString();
            String content = goods.get("comment").toString();
            //???????????? 4000 ???/?????????2,000,000 ???/???
            maSecCheckService.checkMessage(content);
            MallCommentEntity commentEntity = new MallCommentEntity();
            commentEntity.setGoodsId(goodsId);
            commentEntity.setOrderId(orderId);
            commentEntity.setUserId(loginUser.getId());
            commentEntity.setGoodsSpecifitionNameValue(goodsSpecifitionNameValue);
            commentEntity.setStatus(0);
            commentEntity.setType(type);
            commentEntity.setAddTime(new Date());
            commentEntity.setEvalLevel(evalLevel);
            commentEntity.setDeliveryLevel(deliveryLevel);
            commentEntity.setGoodsLevel(Integer.parseInt(goodsLevel));
            commentEntity.setContent(Base64Util.encode(content));

            boolean flag = commentService.save(commentEntity);
            if (flag && null != pics && pics.size() > 0) {
                int i = 0;
                for (String imgLink : pics) {
                    maSecCheckService.checkImage(imgLink);
                    i++;
                    MallCommentPictureEntity pictureVo = new MallCommentPictureEntity();
                    pictureVo.setCommentId(commentEntity.getId());
                    pictureVo.setPicUrl(imgLink);
                    pictureVo.setSort(i);
                    commentPictureService.save(pictureVo);
                }
            }
        }
        return RestResponse.success();
    }

    /**
     * ????????????
     */
    @IgnoreAuth
    @GetMapping("count")
    @ApiOperation(value = "????????????", notes = "????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "query", name = "type", value = "?????????????????????;0??????????????????,1??????????????????", required = true, dataType = "string", example = "1"),
            @ApiImplicitParam(paramType = "query", name = "from", value = "????????????", required = true, dataType = "int", example = "1"),
            @ApiImplicitParam(paramType = "query", name = "goodsId", value = "??????Id", required = true, dataType = "string", example = "1"),
            @ApiImplicitParam(paramType = "query", name = "orderId", value = "??????Id", required = true, dataType = "string", example = "1")
    })
    public RestResponse count(String type, @RequestParam(defaultValue = "0") Integer from, String goodsId, String orderId) {
        Integer goodsCount = commentService.count(new QueryWrapper<MallCommentEntity>().eq(from != 1, "STATUS", 1).eq(StringUtils.isNotBlank(orderId), "ORDER_ID", orderId)
                .eq("TYPE", type).eq(StringUtils.isNotBlank(goodsId), "GOODS_ID", goodsId));

        Map<String, Object> param = new HashMap<>(2);
        param.put("goodsId", goodsId);
        param.put("orderId", orderId);
        param.put("type", type);
        param.put("from", from);
        param.put("status", 1);
        Integer picCount = commentService.queryHasPicTotal(param);

        return RestResponse.success().put("goodsCount", goodsCount).put("picCount", picCount);
    }

    /**
     * ????????????ID??????????????????
     *
     * @return
     */
    @IgnoreAuth
    @GetMapping("list")
    @ApiOperation(value = "????????????", notes = "????????????ID??????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "query", name = "type", value = "?????????????????????;0??????????????????,1??????????????????", required = true, dataType = "string", example = "1"),
            @ApiImplicitParam(paramType = "query", name = "from", value = "????????????, 1 ?????????????????? ???????????????????????????", required = true, dataType = "int", example = "1"),
            @ApiImplicitParam(paramType = "query", name = "orderId", value = "??????Id", required = true, dataType = "string", example = "1"),
            @ApiImplicitParam(paramType = "query", name = "goodsId", value = "??????Id", required = true, dataType = "string", example = "1"),
            @ApiImplicitParam(paramType = "query", name = "order", value = "????????????", allowableValues = "RETAIL_PRICE,SALES", dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "showType", value = "???????????????????????????", allowableValues = "0,1", dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "sortType", value = "????????????", allowableValues = "ASC,DESC", dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "current", value = "????????????", example = "1", dataType = "int"),
            @ApiImplicitParam(paramType = "query", name = "limit", value = "????????????", example = "10", dataType = "int")
    })
    public RestResponse commentList(String type, @RequestParam(defaultValue = "0") Integer from, String orderId, String goodsId, Integer showType, String order, String sortType,
                             @RequestParam(defaultValue = "1") Integer current, @RequestParam(defaultValue = "10") Integer limit) {

        Page<MallCommentEntity> page = new Page<>(current, limit);

        IPage<MallCommentEntity> data = commentService.page(page, new QueryWrapper<MallCommentEntity>().eq("TYPE", type).eq(StringUtils.isNotBlank(goodsId), "GOODS_ID", goodsId)
                .eq(StringUtils.isNotBlank(orderId), "ORDER_ID", orderId).eq(from != 1, "STATUS", 1).orderBy(StringUtils.isNotBlank(order), "ASC".equalsIgnoreCase(sortType), order)
                .exists(showType == 1, "SELECT 1 FROM MALL_COMMENT_PICTURE WHERE MALL_COMMENT.ID = MALL_COMMENT_PICTURE.COMMENT_ID"));

        List<MallCommentEntity> commentList = data.getRecords();

        for (MallCommentEntity commentItem : commentList) {
            commentItem.setContent(Base64Util.decode(commentItem.getContent()));
            commentItem.setUserInfo(userService.getById(commentItem.getUserId()));

            List<MallCommentPictureEntity> commentPictureEntities = commentPictureService.list(
                    new QueryWrapper<MallCommentPictureEntity>().eq("COMMENT_ID", commentItem.getId()));
            commentItem.setCommentPictureEntityList(commentPictureEntities);
        }

        return RestResponse.success().put("data", data);
    }
}

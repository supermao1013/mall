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

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.platform.annotation.IgnoreAuth;
import com.platform.annotation.LoginUser;
import com.platform.common.exception.BusinessException;
import com.platform.common.utils.RestResponse;
import com.platform.common.utils.StringUtils;
import com.platform.modules.mall.entity.MallCouponEntity;
import com.platform.modules.mall.entity.MallUserCouponEntity;
import com.platform.modules.mall.entity.MallUserEntity;
import com.platform.modules.mall.service.MallCouponService;
import com.platform.modules.mall.service.MallUserCouponService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author ?????????
 */
@Slf4j
@RestController
@RequestMapping("/app/coupon")
@Api(tags = "AppCouponController|???????????????")
public class AppCouponController extends AppBaseController {
    @Autowired
    MallUserCouponService userCouponService;
    @Autowired
    MallCouponService couponService;

    /**
     * ?????????????????????
     */
    @GetMapping("/list")
    @ApiOperation(value = "?????????????????????", notes = "?????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "goodsIdList", value = "goodsIdList", dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "brandIdList", value = "brandIdList", dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "status", value = "??????", example = "1", dataType = "int")
    })
    public RestResponse list(@LoginUser MallUserEntity loginUser, String status) {
        String userId = loginUser.getId();
        if (StringUtils.isBlank(userId)) {
            throw new BusinessException("????????????!");
        }
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params = new HashMap<>();
        params.put("userId", userId);
        if (status != null) {
            params.put("status", status);
        }
        List<MallUserCouponEntity> list = userCouponService.queryAll(params);
        return RestResponse.success().put("data", list);
    }

    /**
     * ?????????????????????
     */
    @GetMapping("/selectCoupon")
    @ApiOperation(value = "?????????????????????", notes = "?????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "goodsIdList", value = "goodsIdList", dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "brandIdList", value = "brandIdList", dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "status", value = "??????", example = "1", dataType = "int")
    })
    public RestResponse selectCoupon(@LoginUser MallUserEntity loginUser, String goodsIdList, String brandIdList, String status) {
        String userId = loginUser.getId();
        if (StringUtils.isBlank(userId)) {
            throw new BusinessException("????????????!");
        }
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("nowDate", new Date());
        if (goodsIdList != null) {
            params.put("goodsIds", goodsIdList.split(","));
        }
        if (brandIdList != null) {
            params.put("brandIds", brandIdList.split(","));
        }
        if (status != null) {
            params.put("status", status);
        }
        List<MallUserCouponEntity> list = userCouponService.queryAll(params);
        //???????????????
        params = new HashMap<>();
        params.put("userId", userId);
        params.put("limitType", "0");
        params.put("nowDate", new Date());
        if (status != null) {
            params.put("status", status);
        }
        list.addAll(userCouponService.queryAll(params));

        // ??????
        List<MallUserCouponEntity> data = list.stream().distinct().collect(Collectors.toList());
        return RestResponse.success().put("data", data);
    }

    @IgnoreAuth
    @GetMapping("/couponList")
    @ApiOperation(value = "??????????????????", notes = "??????????????????")
    public RestResponse couponList() {
        List<MallCouponEntity> couponEntityList = couponService.list(new QueryWrapper<MallCouponEntity>()
                .le("BEGIN_GET_TIME", new Date()).ge("END_GET_TIME", new Date()).eq("STATUS", 1)
        );
        return RestResponse.success().put("data", couponEntityList);
    }

    @GetMapping("/getCouponUser")
    @ApiOperation(value = "???????????????", notes = "???????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "couponId", value = "?????????ID", example = "1", required = true, dataType = "string")
    })
    @Transactional(rollbackFor = Exception.class)
    public RestResponse getCouponUser(@LoginUser MallUserEntity loginUser, String couponId) {
        String userId = loginUser.getId();
        if (StringUtils.isBlank(userId)) {
            throw new BusinessException("????????????!");
        }
        MallCouponEntity couponEntity = couponService.getById(couponId);
        if (couponEntity.getStatus() != 1) {
            throw new BusinessException("??????????????????");
        }
        if (System.currentTimeMillis() > couponEntity.getEndGetTime().getTime()) {
            throw new BusinessException("??????????????????");
        }
        if (couponEntity.getBeginGetTime().getTime() > System.currentTimeMillis()) {
            throw new BusinessException("??????????????????");
        }
        if (couponEntity.getSendCount() >= couponEntity.getTotalCount()) {
            throw new BusinessException("??????????????????");
        }
        int count = userCouponService.count(new QueryWrapper<MallUserCouponEntity>().eq("USER_ID", userId).eq("COUPON_ID", couponId));
        if (count >= couponEntity.getLimitUser()) {
            throw new BusinessException("??????????????????" + couponEntity.getLimitUser() + "???");
        }
        MallUserCouponEntity userCouponEntity = new MallUserCouponEntity();
        userCouponEntity.setUserId(userId);
        userCouponEntity.setCouponId(couponId);
        userCouponEntity.setAddTime(new Date());
        userCouponEntity.setType(2);
        userCouponEntity.setStatus(0);
        userCouponService.save(userCouponEntity);
        LambdaQueryWrapper<MallCouponEntity> eq = Wrappers.<MallCouponEntity>lambdaQuery()
                .eq(MallCouponEntity::getSendCount, couponEntity.getSendCount())
                .eq(MallCouponEntity::getId, couponEntity.getId());
        couponEntity.setSendCount(couponEntity.getSendCount() + 1);
        couponService.update(couponEntity, eq);
        return RestResponse.success();
    }

    /**
     * ?????????????????????
     */
    @GetMapping("/userCount")
    @ApiOperation(value = "?????????????????????", notes = "?????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string")
    })
    public RestResponse userCouponCount(@LoginUser MallUserEntity loginUser) {
        String userId = loginUser.getId();
        if (StringUtils.isBlank(userId)) {
            throw new BusinessException("????????????!");
        }
        Map<String, Object> params = new HashMap<>();
        params.put("userId", loginUser.getId());
        params.put("status", 0);
        return RestResponse.success().put("data", userCouponService.queryAll(params).size());
    }
}

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

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.platform.annotation.IgnoreAuth;
import com.platform.annotation.LoginUser;
import com.platform.common.utils.JedisUtil;
import com.platform.common.utils.RestResponse;
import com.platform.common.utils.StringUtils;
import com.platform.modules.mall.entity.MallGoodsEntity;
import com.platform.modules.mall.entity.MallShopsCategoryEntity;
import com.platform.modules.mall.entity.MallShopsEntity;
import com.platform.modules.mall.entity.MallUserEntity;
import com.platform.modules.mall.service.MallGoodsService;
import com.platform.modules.mall.service.MallShopsCategoryService;
import com.platform.modules.mall.service.MallShopsService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import oracle.jdbc.proxy.annotation.Post;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.platform.common.utils.Constant.SHOPS_BIND;

/**
 * ??????
 *
 * @author ?????????
 */
@Slf4j
@RestController
@RequestMapping("/app/shops")
@Api(tags = "AppShopsController|??????????????????")
public class AppShopsController {
    @Autowired
    private MallShopsService shopsService;
    @Autowired
    private MallShopsCategoryService shopsCategoryService;
    @Autowired
    private MallGoodsService goodsService;

    @Autowired
    private JedisUtil jedisUtil;

    /**
     * ????????????
     */
    @IgnoreAuth
    @GetMapping("/shopsList")
    @ApiOperation(value = "????????????", notes = "????????????")
    public RestResponse shopsList() {
        List<MallShopsEntity> shopsEntityList = shopsService.list(
                new QueryWrapper<MallShopsEntity>().select("IMG_URL", "SHOPS_SN", "NAME", "WORK_TIME", "LONGITUDE", "LATITUDE", "DETAILS")
                        .eq("APPLY_STATUS", 1).orderByDesc("SORT"));
        return RestResponse.success().put("data", shopsEntityList);
    }

    /**
     * ????????????
     */
    @IgnoreAuth
    @GetMapping("/detailBySn")
    @ApiOperation(value = "????????????", notes = "????????????")
    @ApiImplicitParam(paramType = "query", name = "shopsSn", value = "??????SN", example = "1", required = true, dataType = "string")
    public RestResponse detailBySn(String shopsSn) {
        MallShopsEntity shopsEntity = shopsService.getOne(new QueryWrapper<MallShopsEntity>().eq("SHOPS_SN", shopsSn), false);
        if (null == shopsEntity) {
            return RestResponse.error("??????????????????");
        }
        return RestResponse.success().put("data", shopsEntity);
    }

    /**
     * ????????????ID????????????????????????
     */
    @IgnoreAuth
    @GetMapping("/shopsCategory")
    @ApiOperation(value = "????????????????????????", notes = "????????????ID????????????????????????")
    @ApiImplicitParam(paramType = "query", name = "shopsId", value = "??????ID", example = "1", required = true, dataType = "string")
    public RestResponse shopsCategory(String shopsId) {
        List<MallShopsCategoryEntity> shopsCategoryEntityList = shopsCategoryService.list(
                new QueryWrapper<MallShopsCategoryEntity>().eq("SHOPS_ID", shopsId).eq("STATUS", 1)
                        .orderByAsc("SORT"));
        if (shopsCategoryEntityList != null && shopsCategoryEntityList.size() > 0) {
            Map<String, Object> params = new HashMap<>(2);
            params.put("isOnSale", 1);
            for (MallShopsCategoryEntity item : shopsCategoryEntityList) {
                params.put("shopsCategoryId", item.getId());
                item.setShopsGoodsList(goodsService.queryAll(params));
            }
        }
        return RestResponse.success().put("data", shopsCategoryEntityList);
    }

    /**
     * ??????????????????????????????
     */
    @IgnoreAuth
    @GetMapping("/shopsCategoryGoods")
    @ApiOperation(value = "??????????????????????????????", notes = "????????????????????????ID??????????????????")
    @ApiImplicitParam(paramType = "query", name = "shopsCategoryId", value = "??????????????????ID", example = "1", required = true, dataType = "string")
    public RestResponse shopsCategoryGoods(String shopsCategoryId) {
        Map<String, Object> params = new HashMap<>(2);
        params.put("shopsCategoryId", shopsCategoryId);
        params.put("isOnSale", 1);
        List<MallGoodsEntity> shopsCategoryEntityList = goodsService.queryAll(params);
        return RestResponse.success().put("data", shopsCategoryEntityList);
    }

    /**
     * ??????????????????????????????
     */
    @PostMapping("/shopsBind")
    @ApiOperation(value = "????????????", notes = "????????????")
    @ApiImplicitParam(paramType = "query", name = "shopsId", value = "??????Id", example = "1", required = true, dataType = "string")
    public RestResponse shopsBind(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        String shopsId = jsonParam.getString("shopsId");
        String checkCode = jsonParam.getString("checkCode");
        if (StringUtils.isNullOrEmpty(checkCode)) {
            return RestResponse.error("?????????????????????");
        }
        String codeCache = jedisUtil.get(SHOPS_BIND + shopsId);
        if (StringUtils.isNullOrEmpty(codeCache)) {
            return RestResponse.error("????????????????????????");
        }
        jedisUtil.del(SHOPS_BIND + shopsId);
        if (!codeCache.equals(checkCode)) {
            return RestResponse.error("???????????????");
        }
        MallShopsEntity shopsEntity = new MallShopsEntity();
        shopsEntity.setId(shopsId);
        shopsEntity.setWithdrawUserId(loginUser.getId());
        shopsService.updateById(shopsEntity);
        return RestResponse.success();
    }
}

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
import com.platform.modules.mall.entity.MallIntegralGoodsEntity;
import com.platform.modules.mall.service.MallIntegralGoodsService;
import com.platform.modules.sys.controller.AbstractController;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 积分商品表Controller
 *
 * @author 李鹏军
 * @since 2021-07-27 15:32:51
 */
@RestController
@RequestMapping("mall/integralgoods")
public class MallIntegralGoodsController extends AbstractController {
    @Autowired
    private MallIntegralGoodsService mallIntegralGoodsService;

    /**
     * 查看所有列表
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @RequestMapping("/queryAll")
    @RequiresPermissions("mall:integralgoods:list")
    public RestResponse queryAll(@RequestParam Map<String, Object> params) {
        List<MallIntegralGoodsEntity> list = mallIntegralGoodsService.queryAll(params);

        return RestResponse.success().put("list", list);
    }

    /**
     * 分页查询积分商品表
     *
     * @param params 查询参数
     * @return RestResponse
     */
    @GetMapping("/list")
    @RequiresPermissions("mall:integralgoods:list")
    public RestResponse list(@RequestParam Map<String, Object> params) {
        Page page = mallIntegralGoodsService.queryPage(params);

        return RestResponse.success().put("page", page);
    }

    /**
     * 根据主键查询详情
     *
     * @param id 主键
     * @return RestResponse
     */
    @RequestMapping("/info/{id}")
    @RequiresPermissions("mall:integralgoods:info")
    public RestResponse info(@PathVariable("id") String id) {
        MallIntegralGoodsEntity mallIntegralGoods = mallIntegralGoodsService.getById(id);

        return RestResponse.success().put("integralgoods", mallIntegralGoods);
    }

    /**
     * 新增积分商品表
     *
     * @param mallIntegralGoods mallIntegralGoods
     * @return RestResponse
     */
    @SysLog("新增积分商品")
    @RequestMapping("/save")
    @RequiresPermissions("mall:integralgoods:save")
    public RestResponse save(@RequestBody MallIntegralGoodsEntity mallIntegralGoods) {
        mallIntegralGoods.setCreateUserId(getUserId());
        mallIntegralGoods.setCreateUserOrgNo(getOrgNo());
        mallIntegralGoods.setCreateTime(new Date());
        mallIntegralGoodsService.add(mallIntegralGoods);

        return RestResponse.success();
    }

    /**
     * 修改积分商品表
     *
     * @param mallIntegralGoods mallIntegralGoods
     * @return RestResponse
     */
    @SysLog("修改积分商品")
    @RequestMapping("/update")
    @RequiresPermissions("mall:integralgoods:update")
    public RestResponse update(@RequestBody MallIntegralGoodsEntity mallIntegralGoods) {

        mallIntegralGoodsService.update(mallIntegralGoods);

        return RestResponse.success();
    }

    /**
     * 根据主键删除积分商品表
     *
     * @param ids ids
     * @return RestResponse
     */
    @SysLog("删除积分商品")
    @RequestMapping("/delete")
    @RequiresPermissions("mall:integralgoods:delete")
    public RestResponse delete(@RequestBody String[] ids) {
        mallIntegralGoodsService.deleteBatch(ids);

        return RestResponse.success();
    }

    /**
     * 积分商品上架、下架
     *
     * @param ids ids
     * @return RestResponse
     */
    @SysLog("积分商品上架、下架")
    @RequestMapping("/changeSale")
    @RequiresPermissions("mall:goods:changeSale")
    public RestResponse changeSale(@RequestBody String[] ids) {
        mallIntegralGoodsService.changeSale(ids);

        return RestResponse.success();
    }
}

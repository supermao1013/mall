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
package com.platform.modules.mall.service.impl;

import cn.binarywang.wx.miniapp.api.WxMaService;
import cn.binarywang.wx.miniapp.bean.WxMaCodeLineColor;
import com.aliyun.oss.common.auth.InvalidCredentialsException;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.platform.common.exception.BusinessException;
import com.platform.common.utils.Query;
import com.platform.modules.mall.dao.MallShopsDao;
import com.platform.modules.mall.entity.MallShopsEntity;
import com.platform.modules.mall.service.MallShopsService;
import com.platform.modules.oss.cloud.UploadFactory;
import me.chanjar.weixin.common.error.WxErrorException;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * 店铺Service实现类
 *
 * @author 李鹏军
 * @since 2019-07-03 13:51:29
 */
@Service("mallShopsService")
public class MallShopsServiceImpl extends ServiceImpl<MallShopsDao, MallShopsEntity> implements MallShopsService {
    @Autowired
    private WxMaService maService;

    @Override
    public List<MallShopsEntity> queryAll(Map<String, Object> params) {
        String name = (String) params.get("name");
        String userId = (String) params.get("userId");
        return baseMapper.selectList(new QueryWrapper<MallShopsEntity>().like(StringUtils.isNotBlank(name), "NAME", name)
                .eq(StringUtils.isNotBlank(userId), "USER_ID", userId));
    }

    @Override
    public IPage queryPage(Map<String, Object> params) {
        Page<MallShopsEntity> page = new Query<MallShopsEntity>(params).getPage();
        return page.setRecords(baseMapper.selectListPage(page, params));
    }

    @Override
    public boolean add(MallShopsEntity mallShops) {
        try {
            byte[] bytes = maService.getQrcodeService().createWxaCodeBytes("/pages/shops/shops?shopsSn=" + mallShops.getShopsSn(), 500, false, new WxMaCodeLineColor("0", "0", "0"), false);
            String url = UploadFactory.build().uploadSuffix(bytes, ".png");
            mallShops.setQrCode(url);
        } catch (WxErrorException e) {
            log.error("生成小程序码失败：" + e.getMessage());
        }
        return this.save(mallShops);
    }

    @Override
    public boolean update(MallShopsEntity mallShops) {
        return this.updateById(mallShops);
    }

    @Override
    public boolean delete(String id) {
        return this.removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteBatch(String[] ids) {
        return this.removeByIds(Arrays.asList(ids));
    }

    @Override
    public boolean myUpdate(MallShopsEntity mallShops, String userId) {
        MallShopsEntity entity = this.getById(mallShops.getId());
        if (!userId.equals(entity.getUserId())) {
            throw new BusinessException("非法操作！");
        }
        entity.setName(mallShops.getName());
        entity.setWorkTime(mallShops.getWorkTime());
        entity.setShopsSn(mallShops.getShopsSn());
        entity.setImgUrl(mallShops.getImgUrl());
        entity.setLongitude(mallShops.getLongitude());
        entity.setLatitude(mallShops.getLatitude());
        entity.setDetails(mallShops.getDetails());
        entity.setTelephone(mallShops.getTelephone());
        entity.setShopDesc(mallShops.getShopDesc());
        entity.setSort(mallShops.getSort());
        return update(entity);
    }

    @Override
    public boolean createQrCode(String id) {
        try {
            MallShopsEntity entity = this.getById(id);
            byte[] bytes = maService.getQrcodeService().createWxaCodeBytes("/pages/shops/shops?shopsSn=" + entity.getShopsSn(), 500, false, new WxMaCodeLineColor("0", "0", "0"), false);
            String url = UploadFactory.build().uploadSuffix(bytes, ".png");
            entity.setQrCode(url);
            update(entity);
        } catch (Exception e) {
            throw new BusinessException("生成小程序码失败：" + e.getMessage());
        }
        return true;
    }


    @Override
    public MallShopsEntity getShopsInfo(String userId) {
        List<MallShopsEntity> shopsEntities = baseMapper.selectList(new QueryWrapper<MallShopsEntity>()
                .eq("USER_ID", userId));
        if (CollectionUtils.isNotEmpty(shopsEntities)) {
            return shopsEntities.get(0);
        }
        return null;
    }

    @Override
    public boolean createQrCodeBind(String id) {
        try {
            MallShopsEntity entity = this.getById(id);
            byte[] bytes = maService.getQrcodeService().createWxaCodeBytes("/pages/shops/shopsBind?shopsSn=" + entity.getShopsSn(), 500, false, new WxMaCodeLineColor("0", "0", "0"), false);
            String url = UploadFactory.build().uploadSuffix(bytes, ".png");
            entity.setQrCodeBind(url);
            update(entity);
        } catch (Exception e) {
            throw new BusinessException("生成绑定小程序码失败：" + e.getMessage());
        }
        return true;
    }
}

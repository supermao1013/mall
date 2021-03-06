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
package com.platform.modules.wx.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.baomidou.mybatisplus.extension.toolkit.SqlHelper;
import com.platform.common.utils.JedisUtil;
import com.platform.common.utils.Query;
import com.platform.modules.wx.dao.WxAccountDao;
import com.platform.modules.wx.entity.WxAccountEntity;
import com.platform.modules.wx.service.WxAccountService;
import lombok.extern.slf4j.Slf4j;
import me.chanjar.weixin.mp.api.WxMpService;
import me.chanjar.weixin.mp.config.WxMpConfigStorage;
import me.chanjar.weixin.mp.config.impl.WxMpDefaultConfigImpl;
import me.chanjar.weixin.mp.config.impl.WxMpRedisConfigImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;

import javax.annotation.PostConstruct;
import java.io.Serializable;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author ?????????
 * @date 2021-05-06 18:30:15
 */
@Slf4j
@Service("wxAccountService")
public class WxAccountServiceImpl extends ServiceImpl<WxAccountDao, WxAccountEntity> implements WxAccountService {

    @Autowired
    WxMpService wxMpService;
    @Autowired
    private JedisUtil jedisUtil;

    @Override
    public IPage queryPage(Map<String, Object> params) {
        String name = (String) params.get("name");

        Page<WxAccountEntity> page = new Query<WxAccountEntity>(params).getPage();

        return baseMapper.selectPage(page,
                new QueryWrapper<WxAccountEntity>().like(StringUtils.hasText(name), "NAME", name)
                        .orderByDesc("TYPE"));
    }

    @PostConstruct
    public void loadWxMpConfigStorages() {
        List<WxAccountEntity> accountList = this.list();
        if (accountList == null || accountList.isEmpty()) {
            log.info("??????????????????????????????????????????????????????");
            return;
        }
        log.info("?????????{}??????????????????", accountList.size());
        accountList.forEach(this::addAccountToRuntime);
    }

    @Override
    public boolean save(WxAccountEntity entity) {
        Assert.notNull(entity, "WxAccount????????????");
        String appid = entity.getAppid();
        //?????????appid???????????????
        if (this.isAccountInRuntime(appid)) {
            log.info("?????????????????????");
            wxMpService.removeConfigStorage(appid);
            this.addAccountToRuntime(entity);

            return SqlHelper.retBool(this.baseMapper.updateById(entity));
        } else {
            //?????????appid???????????????
            log.info("?????????????????????");
            this.addAccountToRuntime(entity);

            return SqlHelper.retBool(this.baseMapper.insert(entity));
        }

    }

    @Override
    public boolean removeByIds(Collection<? extends Serializable> idList) {
        Assert.notEmpty(idList, "WxAccount????????????");

        // ??????wxMpService??????
        log.info("???????????????????????????");
        idList.forEach(id -> wxMpService.removeConfigStorage((String) id));

        return SqlHelper.retBool(this.baseMapper.deleteBatchIds(idList));
    }

    /**
     * ???????????????????????????
     *
     * @param appid
     * @return
     */
    private boolean isAccountInRuntime(String appid) {
        try {
            return wxMpService.switchover(appid);
        } catch (NullPointerException e) {
            // sdk bug???????????????????????????configStorageMap???null?????????
            return false;
        }
    }

    /**
     * ?????????????????????????????????????????????????????????configStorageMap
     *
     * @param entity
     */
    private synchronized void addAccountToRuntime(WxAccountEntity entity) {
        String appid = entity.getAppid();
        WxMpDefaultConfigImpl config = toWxMpConfigStorage(entity);
        try {
            wxMpService.addConfigStorage(appid, config);
        } catch (NullPointerException e) {
            log.info("????????????configStorageMap...");
            Map<String, WxMpConfigStorage> configStorages = new HashMap<>(4);
            configStorages.put(appid, config);
            wxMpService.setMultiConfigStorages(configStorages, appid);
        }
    }

    private WxMpRedisConfigImpl toWxMpConfigStorage(WxAccountEntity entity) {
        WxMpRedisConfigImpl configStorage = new WxMpRedisConfigImpl(jedisUtil, "wx");
        configStorage.setAppId(entity.getAppid());
        configStorage.setSecret(entity.getSecret());
        configStorage.setToken(entity.getToken());
        configStorage.setAesKey(entity.getAesKey());
        return configStorage;
    }
}

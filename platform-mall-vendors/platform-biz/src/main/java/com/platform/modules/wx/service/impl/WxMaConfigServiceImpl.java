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

import cn.binarywang.wx.miniapp.api.WxMaService;
import cn.binarywang.wx.miniapp.config.WxMaConfig;
import cn.binarywang.wx.miniapp.config.impl.WxMaDefaultConfigImpl;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.platform.common.utils.Query;
import com.platform.modules.wx.dao.WxMaConfigDao;
import com.platform.modules.wx.entity.WxMaConfigEntity;
import com.platform.modules.wx.service.WxMaConfigService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.PostConstruct;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 微信小程序配置Service实现类
 *
 * @author 李鹏军
 * @since 2020-04-05 21:58:47
 */
@Slf4j
@Service("wxMaConfigService")
public class WxMaConfigServiceImpl extends ServiceImpl<WxMaConfigDao, WxMaConfigEntity> implements WxMaConfigService {
    @Autowired
    WxMaService wxMaService;

    @Override
    public List<WxMaConfigEntity> queryAll(Map<String, Object> params) {
        return baseMapper.queryAll(params);
    }

    @Override
    public Page queryPage(Map<String, Object> params) {
        //排序
        params.put("sidx", "T.ID");
        params.put("asc", false);
        Page<WxMaConfigEntity> page = new Query<WxMaConfigEntity>(params).getPage();
        return page.setRecords(baseMapper.selectWxMaConfigPage(page, params));
    }

    @PostConstruct
    public void loadWxMaConfigStorages() {
        List<WxMaConfigEntity> list = this.list();
        if (list == null || list.isEmpty()) {
            log.info("未读取到小程序配置，请在管理后台添加");
            return;
        }
        log.info("加载到{}条小程序配置", list.size());

        Map<String, WxMaConfig> result = new HashMap<>();
        WxMaDefaultConfigImpl wxMaInMemoryConfig;
        for (WxMaConfigEntity config : list) {
            wxMaInMemoryConfig = new WxMaDefaultConfigImpl();
            wxMaInMemoryConfig.setAppid(config.getAppId());
            wxMaInMemoryConfig.setSecret(config.getSecret());
            wxMaInMemoryConfig.setToken(config.getToken());
            wxMaInMemoryConfig.setAesKey(config.getAesKey());
            wxMaInMemoryConfig.setMsgDataFormat(config.getMsgDataFormat());
            result.put(config.getAppId(), wxMaInMemoryConfig);
        }
        wxMaService.setMultiConfigs(result, list.get(0).getAppId());

    }

    @Override
    public boolean add(WxMaConfigEntity config) {
        WxMaDefaultConfigImpl wxMaInMemoryConfig = new WxMaDefaultConfigImpl();
        wxMaInMemoryConfig.setAppid(config.getAppId());
        wxMaInMemoryConfig.setSecret(config.getSecret());
        wxMaInMemoryConfig.setToken(config.getToken());
        wxMaInMemoryConfig.setAesKey(config.getAesKey());
        wxMaInMemoryConfig.setMsgDataFormat(config.getMsgDataFormat());
        wxMaService.addConfig(config.getAppId(), wxMaInMemoryConfig);

        return this.save(config);
    }

    @Override
    public boolean update(WxMaConfigEntity config) {
        WxMaDefaultConfigImpl wxMaInMemoryConfig = new WxMaDefaultConfigImpl();
        wxMaInMemoryConfig.setAppid(config.getAppId());
        wxMaInMemoryConfig.setSecret(config.getSecret());
        wxMaInMemoryConfig.setToken(config.getToken());
        wxMaInMemoryConfig.setAesKey(config.getAesKey());
        wxMaInMemoryConfig.setMsgDataFormat(config.getMsgDataFormat());
        wxMaService.addConfig(config.getAppId(), wxMaInMemoryConfig);

        return this.updateById(config);
    }

    @Override
    public boolean delete(String id) {
        wxMaService.removeConfig(getById(id).getAppId());
        return this.removeById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteBatch(String[] ids) {
        return this.removeByIds(Arrays.asList(ids));
    }
}

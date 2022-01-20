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
package com.platform.modules.mall.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.platform.modules.mall.entity.MallOrderEntity;
import com.platform.modules.mall.entity.MallShopsWithdrawEntity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 商家提现Dao
 *
 * @author 李鹏军
 * @date 2020-05-05 08:56:53
 */
@Mapper
public interface MallShopsWithdrawDao extends BaseMapper<MallShopsWithdrawEntity> {

    /**
     * 查询所有列表
     *
     * @param params 查询参数
     * @return List
     */
    List<MallShopsWithdrawEntity> queryAll(@Param("params") Map<String, Object> params);

    /**
     * 自定义分页查询
     *
     * @param page   分页参数
     * @param params 查询参数
     * @return List
     */
    List<MallShopsWithdrawEntity> selectMallShopsWithdrawPage(IPage page, @Param("params") Map<String, Object> params);

    /**
     * 查询可提现订单
     *
     * @param shopsId 查询参数
     * @return Map
     */
    List<MallOrderEntity> selectCanWithdrawList(@Param("shopsId") String shopsId);

    /**
     * 查询关联订单
     *
     * @param withdrawId 查询参数
     * @return Map
     */
    List<MallOrderEntity> selectRelaOrderList(@Param("withdrawId") String withdrawId);

    /**
     * 根据id获取
     *
     * @param id 查询参数
     * @return Map
     */
    MallShopsWithdrawEntity getById(@Param("id") String id);
}

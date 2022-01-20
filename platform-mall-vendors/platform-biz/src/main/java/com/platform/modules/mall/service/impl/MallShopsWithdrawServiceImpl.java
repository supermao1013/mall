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

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.github.binarywang.wxpay.bean.entpay.EntPayRequest;
import com.github.binarywang.wxpay.bean.entpay.EntPayResult;
import com.github.binarywang.wxpay.exception.WxPayException;
import com.github.binarywang.wxpay.service.WxPayService;
import com.platform.common.utils.CharUtil;
import com.platform.common.utils.Query;
import com.platform.common.utils.RestResponse;
import com.platform.common.utils.StringUtils;
import com.platform.modules.mall.dao.MallOrderDao;
import com.platform.modules.mall.dao.MallShopsWithdrawDao;
import com.platform.modules.mall.dao.MallShopsWithdrawOrderDao;
import com.platform.modules.mall.dao.MallUserDao;
import com.platform.modules.mall.entity.*;
import com.platform.modules.mall.service.MallShopsWithdrawService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;

/**
 * 商家提现Service实现类
 *
 * @author 李鹏军
 * @date 2020-05-05 08:56:53
 */
@Service("mallShopsWithdrawService")
public class MallShopsWithdrawServiceImpl extends ServiceImpl<MallShopsWithdrawDao, MallShopsWithdrawEntity> implements MallShopsWithdrawService {

    @Autowired
    private MallUserDao mallUserDao;
    @Autowired
    private MallOrderDao mallOrderDao;
    @Autowired
    private MallShopsWithdrawOrderDao mallShopsWithdrawOrderDao;
    @Autowired
    private WxPayService wxPayService;
    @Value("${wx.pay.spbillCreateIp}")
    private String spbillCreateIp;

    @Override
    public List<MallShopsWithdrawEntity> queryAll(Map<String, Object> params) {
        return baseMapper.queryAll(params);
    }

    @Override
    public Page queryPage(Map<String, Object> params) {
        //排序
        params.put("sidx", "T.id");
        params.put("asc", false);
        Page<MallShopsWithdrawEntity> page = new Query<MallShopsWithdrawEntity>(params).getPage();
        return page.setRecords(baseMapper.selectMallShopsWithdrawPage(page, params));
    }

    @Override
    public boolean add(MallShopsWithdrawEntity mallShopsWithdraw) {
        return this.save(mallShopsWithdraw);
    }

    @Override
    public boolean update(MallShopsWithdrawEntity mallShopsWithdraw) {
        return this.updateById(mallShopsWithdraw);
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

    /**
     * 确认提现
     *
     * @param userCheckId
     * @param withDrawId
     * @return
     */
    @Override
    @Transactional
    public RestResponse confirmWithdraw(String userCheckId, String withDrawId, String approvalRemark) {
        MallShopsWithdrawEntity dbAccount = baseMapper.getById(withDrawId);
        if (dbAccount.getApplyStatus().equals(2)) {
            return RestResponse.error("已确认提现，请勿重复操作");
        }
        if (dbAccount.equals(3)) {
            return RestResponse.error("已拒绝提现");
        }
        // 打款到客户微信账号上
        EntPayResult payResult = null;
        String randomStr = CharUtil.getRandomNum(18).toUpperCase();
        try {
            MallUserEntity toUser = mallUserDao.selectById(dbAccount.getWithdrawUserId());
            EntPayRequest entPayRequest = new EntPayRequest();
            entPayRequest.setAmount(dbAccount.getApplyMoney().multiply(new BigDecimal(100)).intValue()); // todo
            entPayRequest.setSpbillCreateIp(spbillCreateIp);
            entPayRequest.setOpenid(toUser.getOpenId());
            entPayRequest.setCheckName("NO_CHECK");
            // 不校验真实姓名
            if (StringUtils.isNotBlank(toUser.getUserName())) {
                entPayRequest.setReUserName(toUser.getUserName());
            } else {
                entPayRequest.setReUserName(toUser.getNickname());
            }
            entPayRequest.setNonceStr(randomStr);
            entPayRequest.setPartnerTradeNo(dbAccount.getId());
            entPayRequest.setDescription("商家提现");
            payResult = wxPayService.getEntPayService().entPay(entPayRequest);
        } catch (WxPayException e) {
            return RestResponse.error(e.getCustomErrorMsg());
        }
        if (null != payResult && payResult.getResultCode().equals("SUCCESS") && payResult.getReturnCode().equals("SUCCESS")) {
            //
            dbAccount.setApplyStatus(2);
            dbAccount.setApprover(userCheckId);
            dbAccount.setApprovalTime(new Date());
            dbAccount.setApprovalRemark(approvalRemark);
            baseMapper.updateById(dbAccount);
        } else {
            if (null != payResult.getErrCodeDes()) {
                return RestResponse.error(payResult.getErrCodeDes());
            } else {
                return RestResponse.error(payResult.getReturnMsg());
            }
        }
        return RestResponse.success();
    }

    /**
     * 拒绝提现
     *
     * @param userCheckId
     * @param withDrawId
     * @return
     */
    @Override
    @Transactional
    public RestResponse refuseWithdraw(String userCheckId, String withDrawId, String approvalRemark) {
        MallShopsWithdrawEntity dbAccount = baseMapper.getById(withDrawId);
        if (dbAccount.getApplyStatus().equals(2)) {
            return RestResponse.error("已确认，无法回退");
        }
        if (dbAccount.getApplyStatus().equals(3)) {
            return RestResponse.error("请勿重复操作");
        }
        dbAccount.setApprover(userCheckId);
        dbAccount.setApprovalRemark(approvalRemark);
        dbAccount.setApplyStatus(3);
        dbAccount.setApprovalTime(new Date());
        baseMapper.updateById(dbAccount);
        return RestResponse.success();
    }

    @Override
    @Transactional
    public RestResponse withdrawApply(String userId, String shopsId, String withdrawUserId, List<String> orderIds) {
        List<MallOrderEntity> orderEntities = mallOrderDao.selectBatchIds(orderIds);
        BigDecimal applyMoney = orderEntities.stream().map(MallOrderEntity::getActualPrice).reduce(BigDecimal.ZERO, BigDecimal::add);
        MallShopsWithdrawEntity dbAccount = new MallShopsWithdrawEntity();
        dbAccount.setApplyMoney(applyMoney);
        dbAccount.setUserId(userId);
        dbAccount.setShopsId(shopsId);
        dbAccount.setApplyType(1);
        dbAccount.setApplyTime(new Date());
        dbAccount.setApplyStatus(1);
        dbAccount.setWithdrawUserId(withdrawUserId);
        baseMapper.insert(dbAccount);
        //
        orderEntities.stream().forEach(item -> {
            MallShopsWithdrawOrderEntity shopsWithdrawOrderEntity = new MallShopsWithdrawOrderEntity();
            shopsWithdrawOrderEntity.setOrderId(item.getId());
            shopsWithdrawOrderEntity.setWithdrawId(dbAccount.getId());
            mallShopsWithdrawOrderDao.insert(shopsWithdrawOrderEntity);
        });
        return RestResponse.success();
    }

    @Override
    public MallShopsWithdrawEntity selectById(String withdrawId) {
        return baseMapper.getById(withdrawId);
    }

    @Override
    public List<MallOrderEntity> selectCanWithdrawList(String shopsId) {
        return baseMapper.selectCanWithdrawList(shopsId);
    }

    @Override
    public List<MallOrderEntity> selectRelaOrderList(String withdrawId) {
        return baseMapper.selectRelaOrderList(withdrawId);
    }
}

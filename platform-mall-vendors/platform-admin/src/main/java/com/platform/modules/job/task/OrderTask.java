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
package com.platform.modules.job.task;

import com.platform.common.utils.Constant;
import com.platform.common.utils.StringUtils;
import com.platform.modules.mall.entity.MallGroupBuyingRecordEntity;
import com.platform.modules.mall.entity.MallOrderEntity;
import com.platform.modules.mall.service.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 订单定时任务
 * orderTask为spring bean的名称
 *
 * @author 李鹏军
 */
@Slf4j
@Component("orderTask")
public class OrderTask {
    private final PayService payService;
    private final MallOrderService orderService;
    private final MallGoodsService goodsService;
    private final MallUserCouponService userCouponService;
    private final MallGroupBuyingRecordService buyingRecordService;

    @Autowired
    public OrderTask(PayService payService, MallGoodsService goodsService, MallOrderService orderService, MallUserCouponService userCouponService, MallGroupBuyingRecordService buyingRecordService) {
        this.payService = payService;
        this.goodsService = goodsService;
        this.orderService = orderService;
        this.userCouponService = userCouponService;
        this.buyingRecordService = buyingRecordService;
    }

    /**
     * 过期自动取消订单
     */
    @SuppressWarnings(value = "unused")
    @Transactional(rollbackFor = Exception.class)
    public void expireOrder() {
        log.info("--------------------------开始执行过期自动取消订单任务--------------------------");

        //等待付款的订单
        List<MallOrderEntity> orderList = orderService.lambdaQuery().lt(MallOrderEntity::getOrderStatus, Constant.OrderStatus.YGQ.getValue()).list();
        if (null != orderList && orderList.size() > 0) {
            log.info("待付款订单数：" + orderList.size());

            List<MallOrderEntity> list = new ArrayList<>();

            //当前时间大于过期时间
            orderList.stream().filter(item -> new Date().after(item.getExpireTime()))
                    .forEach(order -> {
                        order.setOrderStatus(Constant.OrderStatus.YQX.getValue());
                        list.add(order);

                        //取消的订单释放商品库存
                        goodsService.backGoodsNumber(order);
                        //退回优惠券
                        if (StringUtils.isNotBlank(order.getCouponId())) {
                            userCouponService.backCoupon(order.getId());
                        }
                    });
            if (list.size() > 0) {
                orderService.updateBatchById(list);
            }
        }
        log.info("--------------------------结束过期自动取消订单任务--------------------------");
    }

    /**
     * 过期未完成拼团订单任务
     */
    @SuppressWarnings(value = "unused")
    @Transactional(rollbackFor = Exception.class)
    public void expireGroup() {
        log.info("--------------------------开始执行过期未完成拼团订单任务--------------------------");

        //正在拼团的记录
        List<MallGroupBuyingRecordEntity> groupList = buyingRecordService.lambdaQuery().eq(MallGroupBuyingRecordEntity::getStatus, 1).list();
        if (null != groupList && groupList.size() > 0) {
            log.info("正在拼团数：" + groupList.size());

            List<MallGroupBuyingRecordEntity> list = new ArrayList<>();

            //当前时间大于过期时间
            groupList.stream().filter(item -> new Date().after(item.getExpireTime()))
                    .forEach(group -> {
                        group.setStatus(0);
                        group.setUpdateTime(new Date());
                        group.setEndTime(new Date());
                        list.add(group);

                        // 过期退款
                        payService.refund(orderService.getById(group.getOrderSn()), group.getPrice().toString());
                    });
            if (list.size() > 0) {
                buyingRecordService.updateBatchById(list);
            }
        }
        log.info("--------------------------结束过期未完成拼团订单任务--------------------------");
    }

}

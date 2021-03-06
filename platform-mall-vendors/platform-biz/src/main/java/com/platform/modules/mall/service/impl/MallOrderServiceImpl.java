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

import cn.afterturn.easypoi.excel.ExcelExportUtil;
import cn.afterturn.easypoi.excel.entity.ExportParams;
import cn.afterturn.easypoi.excel.entity.params.ExcelExportEntity;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.platform.common.exception.BusinessException;
import com.platform.common.utils.Constant;
import com.platform.common.utils.DateUtils;
import com.platform.common.utils.Query;
import com.platform.common.utils.StringUtils;
import com.platform.modules.mall.dao.MallOrderDao;
import com.platform.modules.mall.dao.MallShippingDao;
import com.platform.modules.mall.entity.MallOrderEntity;
import com.platform.modules.mall.entity.MallOrderGoodsEntity;
import com.platform.modules.mall.entity.MallShippingEntity;
import com.platform.modules.mall.service.MallDistAmountScheduledService;
import com.platform.modules.mall.service.MallOrderGoodsService;
import com.platform.modules.mall.service.MallOrderService;
import com.platform.modules.mall.service.WxSendMsgService;
import org.apache.commons.io.IOUtils;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.util.*;

/**
 * ?????????Service?????????
 *
 * @author ?????????
 * @since 2019-07-05 19:29:18
 */
@Service("mallOrderService")
public class MallOrderServiceImpl extends ServiceImpl<MallOrderDao, MallOrderEntity> implements MallOrderService {
    @Autowired
    private MallShippingDao shippingDao;
    @Autowired
    private WxSendMsgService sendMsgService;
    @Autowired
    private MallDistAmountScheduledService mallDistAmountScheduledService;
    @Autowired
    private MallOrderGoodsService orderGoodsService;

    @Override
    public List<MallOrderEntity> queryAll(Map<String, Object> params) {
        return baseMapper.queryAll(params);
    }

    @Override
    public Page<MallOrderEntity> queryPage(Map<String, Object> params) {
        //??????
        params.put("sidx", "T.ADD_TIME");
        params.put("asc", false);
        Page<MallOrderEntity> page = new Query<MallOrderEntity>(params).getPage();
        return page.setRecords(baseMapper.selectMallOrderPage(page, params));
    }

    @Override
    public boolean add(MallOrderEntity mallOrder) {
        return this.save(mallOrder);
    }

    @Override
    public boolean update(MallOrderEntity mallOrder) {
        return this.updateById(mallOrder);
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
    public boolean sendGoods(MallOrderEntity orderEntity) {
        MallOrderEntity order = baseMapper.selectById(orderEntity.getId());
        //????????????
        Integer payStatus = order.getPayStatus();
        if (!Constant.PayStatus.YFK.getValue().equals(payStatus)) {
            throw new BusinessException("?????????????????????");
        }

        MallShippingEntity shippingEntity = shippingDao.selectById(orderEntity.getShippingId());
        if (null != shippingEntity) {
            order.setShippingName(shippingEntity.getName());
            order.setShippingCode(shippingEntity.getCode());
        }
        order.setShippingId(orderEntity.getShippingId());
        order.setShippingNo(orderEntity.getShippingNo());
        order.setPostalCode(orderEntity.getPostalCode());
        //???????????????
        order.setConfirmTime(new Date());
        order.setOrderStatus(Constant.OrderStatus.YFH.getValue());
        //?????????
        order.setShippingStatus(Constant.ShippingStatus.YFH.getValue());
        update(order);

        //????????????
        return sendMsgService.notifyPaySuccess(order, 5);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmReceive(String id) {
        MallOrderEntity orderEntity = baseMapper.selectById(id);
        //????????????
        Integer shippingStatus = orderEntity.getShippingStatus();
        //????????????
        Integer payStatus = orderEntity.getPayStatus();
        if (!Constant.PayStatus.YFK.getValue().equals(payStatus)) {
            throw new BusinessException("??????????????????????????????????????????");
        }
        if (!Constant.ShippingStatus.YFH.getValue().equals(shippingStatus)) {
            throw new BusinessException("?????????????????????????????????????????????????????????");
        }
        orderEntity.setShippingStatus(Constant.ShippingStatus.YSH.getValue());
        orderEntity.setOrderStatus(Constant.OrderStatus.QRSH.getValue());
        update(orderEntity);

        // ??????????????????????????????
        if (orderEntity.getOrderType() != 4) {
            mallDistAmountScheduledService.addAmountScheduled(orderEntity.getId());
        }
    }

    @Override
    public Map<String, Object> queryUserCountMap(Map<String, Object> params) {
        return baseMapper.queryUserCountMap(params);
    }

    @Override
    public MallOrderEntity queryById(String orderId) {

        return baseMapper.queryById(orderId);
    }

    @Override
    public List<Map<String, Object>> shopsGoodsSalesCount(Map<String, Object> params) {
        return baseMapper.shopsGoodsSalesCount(params);
    }

    @Override
    public List<Map<String, Object>> allShopsGoodsSalesCount(Map<String, Object> params) {
        return baseMapper.allShopsGoodsSalesCount(params);
    }

    @Override
    public void exportOrderExcel(Map<String, Object> params, HttpServletResponse response) {
        // ??????????????????
        List<MallOrderEntity> list = baseMapper.queryAll(params);
        try {
            // ??????ExcelExportEntity??????Map????????????key
            List<ExcelExportEntity> keyList = new ArrayList<>();

            // ??????????????????cell,??????Map????????????????????????????????????key
            // ??????ExcelExportEntity??????????????????????????????????????????rowMap.size()????????????
            ExcelExportEntity excelExportEntity = new ExcelExportEntity("????????????", "userName");
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("????????????", "orderSn");
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("????????????", "orderType");
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("????????????", "payStatus");
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("????????????(???)", "orderPrice");
            excelExportEntity.setStatistics(true);
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("????????????(???)", "actualPrice");
            excelExportEntity.setStatistics(true);
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("??????????????????", "goodsNameList");
            excelExportEntity.setWrap(true);
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("???????????????", "goodsCategoryCount");
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("????????????", "orderStatus");
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("????????????", "shippingStatus");
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("?????????", "consignee");
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("?????????", "mobile");
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("????????????", "address");
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("????????????", "addTime");
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("????????????", "payTime");
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("????????????", "shippingName");
            keyList.add(excelExportEntity);
            excelExportEntity = new ExcelExportEntity("????????????", "shippingNo");
            keyList.add(excelExportEntity);

            // Map?????????????????????????????????List??????????????????
            List<Map<String, Object>> rowDataList = new ArrayList<>();
            Map<String, Object> rowMap;
            List<MallOrderGoodsEntity> orderGoodsEntityList;
            // ????????????????????????
            for (MallOrderEntity item : list) {
                // ???????????????????????????????????????
                orderGoodsEntityList = orderGoodsService.list(new QueryWrapper<MallOrderGoodsEntity>().eq("ORDER_ID", item.getId()));
                StringBuilder goodsNameList = new StringBuilder();
                orderGoodsEntityList.forEach(og -> {
                    goodsNameList.append(og.getGoodsName()).append(StringUtils.isBlank(og.getGoodsSpecifitionNameValue()) ? "" : "???" + og.getGoodsSpecifitionNameValue() + "???").append("???").append(og.getNumber()).append("??????\r\n");
                });

                // ??????Map????????????????????????????????????????????????????????????????????????Map???
                rowMap = new HashMap<>(32);
                rowMap.put("userName", item.getUserName());
                rowMap.put("orderSn", item.getOrderSn());
                rowMap.put("orderType", item.getOrderTypeText());
                rowMap.put("payStatus", item.getPayStatusText());
                rowMap.put("orderPrice", item.getOrderPrice());
                rowMap.put("actualPrice", item.getActualPrice());
                rowMap.put("goodsNameList", goodsNameList);
                rowMap.put("goodsCategoryCount", orderGoodsEntityList.size());
                rowMap.put("orderStatus", item.getOrderStatusText());
                rowMap.put("shippingStatus", item.getShippingStatusText());
                rowMap.put("consignee", item.getConsignee());
                rowMap.put("mobile", item.getMobile());
                rowMap.put("address", item.getAddress());
                rowMap.put("addTime", DateUtils.format(item.getAddTime(), DateUtils.DATE_TIME_PATTERN));
                rowMap.put("payTime", DateUtils.format(item.getPayTime(), DateUtils.DATE_TIME_PATTERN));
                rowMap.put("shippingName", item.getShippingName());
                rowMap.put("shippingNo", item.getShippingNo());
                rowDataList.add(rowMap);
            }

            // ????????????
            StringBuilder sb = new StringBuilder();
            for (String obj : params.keySet()) {
                if (!"token".equalsIgnoreCase(obj) && !StringUtils.isNullOrEmpty(params.get(obj))) {
                    sb.append(obj).append(" = ").append(params.get(obj)).append(" ");
                }
            }
            // ????????????
            String exportDate = DateUtils.format(new Date(), DateUtils.DATE_TIME_PATTERN);
            // excel????????????
            ExportParams exportParams = new ExportParams("????????????" + exportDate + "??????????????????" + sb.toString(), "????????????");
            exportParams.setAutoSize(true);
            exportParams.setHeaderColor(HSSFColor.HSSFColorPredefined.YELLOW.getIndex());
            exportParams.setColor(HSSFColor.HSSFColorPredefined.RED.getIndex());

            // ??????workbook ?????????
            Workbook workbook = ExcelExportUtil.exportExcel(exportParams, keyList, rowDataList);
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            workbook.write(bos);
            byte[] barray = bos.toByteArray();
            response.reset();
            response.setHeader("Content-Disposition", "attachment; filename=" + exportDate + ".xls");
            response.addHeader("Content-Length", "" + barray.length);
            response.setContentType("application/octet-stream; charset=UTF-8");
            IOUtils.write(barray, response.getOutputStream());
        } catch (Exception e) {
            throw new BusinessException("?????????????????????" + e.getMessage());
        }
    }
}

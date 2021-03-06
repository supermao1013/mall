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

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.platform.annotation.IgnoreAuth;
import com.platform.annotation.LoginUser;
import com.platform.common.constant.RedisKeyConst;
import com.platform.common.exception.BusinessException;
import com.platform.common.utils.Constant;
import com.platform.common.utils.JedisUtil;
import com.platform.common.utils.RestResponse;
import com.platform.common.utils.StringUtils;
import com.platform.modules.app.entity.BuyGoodsVo;
import com.platform.modules.mall.entity.*;
import com.platform.modules.mall.service.*;
import com.platform.modules.sys.service.SysConfigService;
import io.swagger.annotations.*;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * ?????????
 *
 * @author ?????????
 */
@Slf4j
@RestController
@RequestMapping("/app/cart")
@Api(tags = "AppCartController|???????????????")
public class AppCartController extends AppBaseController {
    @Autowired
    private MallCartService cartService;
    @Autowired
    private MallGoodsService goodsService;
    @Autowired
    private MallOrderGoodsService orderGoodsService;
    @Autowired
    private MallAddressService addressService;
    @Autowired
    private SysConfigService sysConfigService;
    @Autowired
    private MallGoodsSkuService goodsSkuService;
    @Autowired
    private MallOrderService orderService;
    @Autowired
    private MallCouponService couponService;
    @Autowired
    private MallDistPromoService mallDistPromoService;
    @Autowired
    private MallShopsService mallShopsService;
    @Autowired
    private MallIntegralGoodsService integralGoodsService;
    @Autowired
    private JedisUtil jedisUtil;

    /**
     * ???????????????????????????????????????????????????????????????????????????????????????????????????
     */
    @GetMapping("myCart")
    @ApiOperation(value = "?????????????????????", notes = "???????????????????????????????????????????????????????????????????????????????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "header", name = "shopsId", value = "shopsId", dataType = "string")
    })
    public RestResponse myCart(@LoginUser MallUserEntity loginUser) {
        return RestResponse.success(getCart(loginUser));
    }

    /**
     * ???????????????????????????????????????
     */
    @GetMapping("addByOrder")
    @ApiOperation(value = "????????????", notes = "??????????????????????????????????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "orderId", value = "??????ID", required = true, dataType = "string", example = "1")
    })
    public RestResponse addByOrder(@LoginUser MallUserEntity loginUser, String orderId) {
        Map<String, Object> params = new HashMap<>(2);
        params.put("orderId", orderId);
        List<MallOrderGoodsEntity> orderGoodsVos = orderGoodsService.queryAll(params);
        List<MallCartEntity> addCartVos = new ArrayList<>();
        StringBuilder tipsMsg = new StringBuilder();
        String shopsId = null;
        List<MallCartEntity> promoList = new ArrayList<>();
        for (MallOrderGoodsEntity orderGoodsVo : orderGoodsVos) {
            //??????????????????????????????
            MallGoodsEntity goodsInfo = goodsService.getById(orderGoodsVo.getGoodsId());
            if (null == goodsInfo || goodsInfo.getIsOnSale() == 0) {
                tipsMsg.append(orderGoodsVo.getGoodsName()).append("??????????????????");
                continue;
            }
            MallCartEntity cartInfo = new MallCartEntity();
            cartInfo.setCreateTime(new Date());

            MallOrderEntity order = orderService.getById(orderId);
            if (order != null) {
                shopsId = order.getShopsId();
                cartInfo.setShopsId(shopsId);
            }

            String skuId = orderGoodsVo.getSkuId();
            List<MallCartEntity> cartInfoList = cartService.list(new QueryWrapper<MallCartEntity>().eq("GOODS_ID", orderGoodsVo.getGoodsId())
                    .eq(StringUtils.isNotBlank(shopsId), "SHOPS_ID", shopsId).eq(StringUtils.isNotBlank(skuId), "SKU_ID", skuId).eq("USER_ID", loginUser.getId()));
            if (null != cartInfoList && cartInfoList.size() > 0) {
                //??????????????? ??????+1
                cartInfo = cartInfoList.get(0);
                cartInfo.setNumber(cartInfo.getNumber() + 1);
            } else {
                cartInfo.setGoodsId(orderGoodsVo.getGoodsId());
                cartInfo.setGoodsSn(orderGoodsVo.getGoodsSn());
                cartInfo.setGoodsName(orderGoodsVo.getGoodsName());
                cartInfo.setListPicUrl(orderGoodsVo.getListPicUrl());
                cartInfo.setNumber(orderGoodsVo.getNumber());
                cartInfo.setUserId(loginUser.getId());

                //????????????????????????
                MallGoodsSkuEntity productInfo = goodsSkuService.getById(orderGoodsVo.getSkuId());
                cartInfo.setRetailPrice(productInfo.getRetailPrice());
                cartInfo.setMarketPrice(productInfo.getMarketPrice());

                cartInfo.setShopsId(shopsId);
                cartInfo.setGoodsSpecifitionNameValue(orderGoodsVo.getGoodsSpecifitionNameValue());
                cartInfo.setChecked(1);
                cartInfo.setSkuId(orderGoodsVo.getSkuId());

                promoList.add(cartInfo); // ???????????????
            }
            addCartVos.add(cartInfo);
        }
        if (addCartVos.size() < 1) {
            return RestResponse.error(tipsMsg.substring(0, tipsMsg.length() - 1));
        }
        cartService.saveOrUpdateBatch(addCartVos);

        if (StringUtils.isNullOrEmpty(tipsMsg.toString())) {
            tipsMsg = new StringBuilder("????????????");
        }

        // ??????????????????
        for (MallCartEntity entity : promoList) {
            String skuId = entity.getSkuId();
            List<MallCartEntity> cartInfoList = cartService.list(new QueryWrapper<MallCartEntity>().eq("GOODS_ID", entity.getGoodsId())
                    .eq(StringUtils.isNotBlank(shopsId), "SHOPS_ID", shopsId).eq(StringUtils.isNotBlank(skuId), "SKU_ID", skuId).eq("USER_ID", loginUser.getId()));
            if (null != cartInfoList && cartInfoList.size() > 0) {
                MallCartEntity cartInfo = cartInfoList.get(0);
                MallDistPromoEntity promoEntity = mallDistPromoService.getOne(new QueryWrapper<MallDistPromoEntity>().eq("ORDER_ID", orderId).eq("GOODS_ID", cartInfo.getGoodsId()).eq(StringUtils.isNotBlank(skuId), "SKU_ID", skuId));
                if (promoEntity == null) {
                    continue;
                }
                MallDistPromoEntity mallDistPromoEntity = new MallDistPromoEntity();
                mallDistPromoEntity.setCartId(cartInfo.getId());
                mallDistPromoEntity.setStatus(Constant.PromoStatus.CART.getValue());
                mallDistPromoEntity.setGoodsId(cartInfo.getGoodsId());
                mallDistPromoEntity.setUserId(promoEntity.getUserId());
                mallDistPromoEntity.setSkuId(cartInfo.getSkuId());
                mallDistPromoService.addPromoRecord(loginUser.getId(), mallDistPromoEntity);
            }
        }

        return RestResponse.success(tipsMsg.toString());
    }

    /**
     * ????????????????????????
     */
    @PostMapping("add")
    @ApiOperation(value = "???????????????", notes = "????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "skuId", value = "1"),
                    @ExampleProperty(mediaType = "goodsId", value = "1"),
                    @ExampleProperty(mediaType = "number", value = "1"),
                    @ExampleProperty(mediaType = "selectedText", value = "1"),
                    @ExampleProperty(mediaType = "shopsId", value = "1"),
                    @ExampleProperty(mediaType = "referrerUserId", value = "1")
            }), required = true, dataType = "string")
    })
    public RestResponse add(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        String goodsId = jsonParam.getString("goodsId");
        String skuId = jsonParam.getString("skuId");
        Integer number = jsonParam.getInteger("number");
        String selectedText = jsonParam.getString("selectedText");
        String shopsId = jsonParam.getString("shopsId");
        String referrerUserId = jsonParam.getString("referrerUserId");

        //??????????????????????????????
        MallGoodsEntity goodsInfo = goodsService.getById(goodsId);
        if (null == goodsInfo || goodsInfo.getIsOnSale() == 0) {
            return RestResponse.error("??????????????????");
        }

        MallGoodsSkuEntity productVo = goodsSkuService.getById(skuId);

        //?????????????????????????????????????????????
        List<MallCartEntity> cartInfoList = cartService.list(new QueryWrapper<MallCartEntity>().eq("GOODS_ID", goodsId)
                .eq(StringUtils.isNotBlank(shopsId), "SHOPS_ID", shopsId)
                .eq(StringUtils.isNotBlank(skuId), "SKU_ID", skuId).eq("USER_ID", loginUser.getId()));
        MallCartEntity cartInfo = CollectionUtils.isNotEmpty(cartInfoList) ? cartInfoList.get(0) : null;
        if (null == cartInfo) {
            cartInfo = new MallCartEntity();
            cartInfo.setCreateTime(new Date());
            cartInfo.setSkuId(skuId);
            cartInfo.setGoodsId(goodsId);
            cartInfo.setGoodsSn(productVo != null ? productVo.getGoodsSn() : goodsInfo.getGoodsSn());
            cartInfo.setGoodsName(goodsInfo.getName());
            cartInfo.setListPicUrl(goodsInfo.getListPicUrl());
            cartInfo.setNumber(number);
            cartInfo.setUserId(loginUser.getId());
            cartInfo.setRetailPrice(productVo != null ? productVo.getRetailPrice() : goodsInfo.getRetailPrice());
            cartInfo.setShopsId(shopsId);
            cartInfo.setMarketPrice(productVo != null ? productVo.getMarketPrice() : goodsInfo.getMarketPrice());
            cartInfo.setChecked(1);
            if (StringUtils.isNotBlank(selectedText)) {
                cartInfo.setGoodsSpecifitionNameValue(selectedText);
            }
            cartService.save(cartInfo);

            // ??????????????????
            MallDistPromoEntity mallDistPromoEntity = new MallDistPromoEntity();
            mallDistPromoEntity.setCartId(cartInfo.getId());
            mallDistPromoEntity.setStatus(Constant.PromoStatus.CART.getValue());
            mallDistPromoEntity.setGoodsId(cartInfo.getGoodsId());
            mallDistPromoEntity.setUserId(referrerUserId);
            mallDistPromoEntity.setSkuId(cartInfo.getSkuId());
            mallDistPromoService.addPromoRecord(loginUser.getId(), mallDistPromoEntity);
        } else {
            //????????????????????????????????????????????????
            cartInfo.setNumber(cartInfo.getNumber() + number);
            cartService.update(cartInfo);
        }
        return RestResponse.success(getCart(loginUser));
    }

    /**
     * ???????????????sku
     */
    @PostMapping("updateSku")
    @ApiOperation(value = "???????????????sku", notes = "???????????????sku")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "skuId", value = "1"),
                    @ExampleProperty(mediaType = "goodsId", value = "1"),
                    @ExampleProperty(mediaType = "number", value = "1"),
                    @ExampleProperty(mediaType = "selectedText", value = "1"),
                    @ExampleProperty(mediaType = "shopsId", value = "1"),
                    @ExampleProperty(mediaType = "referrerUserId", value = "1")
            }), required = true, dataType = "string")
    })
    public RestResponse updateSku(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        String goodsId = jsonParam.getString("goodsId");
        String skuId = jsonParam.getString("skuId");
        Integer number = jsonParam.getInteger("number");
        String selectedText = jsonParam.getString("selectedText");
        String shopsId = jsonParam.getString("shopsId");
        String referrerUserId = jsonParam.getString("referrerUserId");

        //??????????????????????????????
        MallGoodsEntity goodsInfo = goodsService.getById(goodsId);
        if (null == goodsInfo || goodsInfo.getIsOnSale() == 0) {
            return RestResponse.error("??????????????????");
        }

        MallGoodsSkuEntity productVo = goodsSkuService.getById(skuId);

        //?????????????????????????????????????????????
        MallCartEntity cartInfo = cartService.getOne(new QueryWrapper<MallCartEntity>().eq("GOODS_ID", goodsId)
                .eq(StringUtils.isNotBlank(shopsId), "SHOPS_ID", shopsId).eq("USER_ID", loginUser.getId()), false);

        if (null != cartInfo) {
            cartInfo.setSkuId(skuId);
            cartInfo.setGoodsId(goodsId);
            cartInfo.setGoodsSn(productVo != null ? productVo.getGoodsSn() : goodsInfo.getGoodsSn());
            cartInfo.setGoodsName(goodsInfo.getName());
            cartInfo.setListPicUrl(goodsInfo.getListPicUrl());
            cartInfo.setNumber(number);
            cartInfo.setUserId(loginUser.getId());
            cartInfo.setRetailPrice(productVo != null ? productVo.getRetailPrice() : goodsInfo.getRetailPrice());
            cartInfo.setShopsId(shopsId);
            cartInfo.setMarketPrice(productVo != null ? productVo.getMarketPrice() : goodsInfo.getMarketPrice());
            if (StringUtils.isNotBlank(selectedText)) {
                cartInfo.setGoodsSpecifitionNameValue(selectedText);
            }
            cartService.update(cartInfo);

            // ??????????????????
            MallDistPromoEntity mallDistPromoEntity = new MallDistPromoEntity();
            mallDistPromoEntity.setCartId(cartInfo.getId());
            mallDistPromoEntity.setStatus(Constant.PromoStatus.CART.getValue());
            mallDistPromoEntity.setGoodsId(cartInfo.getGoodsId());
            mallDistPromoEntity.setUserId(referrerUserId);
            mallDistPromoEntity.setSkuId(cartInfo.getSkuId());
            mallDistPromoService.addPromoRecord(loginUser.getId(), mallDistPromoEntity);
        }
        return RestResponse.success(getCart(loginUser));
    }

    /**
     * ????????????????????????
     */
    @PostMapping("minus")
    @ApiOperation(value = "???????????????", notes = "????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "goodsId", value = "1"),
                    @ExampleProperty(mediaType = "number", value = "1"),
                    @ExampleProperty(mediaType = "shopsId", value = "1")
            }), required = true, dataType = "string")
    })
    public RestResponse minus(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        String goodsId = jsonParam.getString("goodsId");
        Integer number = jsonParam.getInteger("number");
        String shopsId = jsonParam.getString("shopsId");
        //??????????????????????????????
        MallGoodsEntity goodsInfo = goodsService.getById(goodsId);
        if (null == goodsInfo || goodsInfo.getIsOnSale() == 0) {
            return RestResponse.error("??????????????????");
        }
        //?????????????????????????????????????????????
        Map<String, Object> cartParam = new HashMap<>(8);
        cartParam.put("goodsId", goodsId);
        cartParam.put("userId", loginUser.getId());
        if (StringUtils.isNotBlank(shopsId)) {
            cartParam.put("shopsId", shopsId);
        } else {
            cartParam.put("normal", 1);
        }
        List<MallCartEntity> cartInfoList = cartService.queryAll(cartParam);
        MallCartEntity cartInfo;
        int cartNum = 0;
        if (null != cartInfoList && cartInfoList.size() > 0) {
            cartInfo = cartInfoList.get(0);
            if (!loginUser.getId().equals(cartInfo.getUserId())) {
                return RestResponse.error("???????????????");
            }
            if (cartInfo.getNumber() > number) {
                cartInfo.setNumber(cartInfo.getNumber() - number);
                cartService.update(cartInfo);
                cartNum = cartInfo.getNumber();
            } else if (cartInfo.getNumber() == 1) {
                cartService.delete(cartInfo.getId());
            }

        }
        return RestResponse.success().put("data", cartNum);
    }

    /**
     * ??????????????????????????????
     */
    @PostMapping("update")
    @ApiOperation(value = "???????????????", notes = "??????????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "goodsId", value = "1"),
                    @ExampleProperty(mediaType = "number", value = "1"),
                    @ExampleProperty(mediaType = "shopsId", value = "1")
            }), required = true, dataType = "string")
    })
    public RestResponse update(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        String goodsId = jsonParam.getString("goodsId");
        Integer number = jsonParam.getInteger("number");
        String id = jsonParam.getString("id");
        //??????????????????????????????
        MallGoodsEntity goodsInfo = goodsService.getById(goodsId);
        if (null == goodsInfo || goodsInfo.getIsOnSale() == 0) {
            return RestResponse.error("??????????????????");
        }
        if (null != id) {
            MallCartEntity cartInfo = cartService.getById(id);
            if (!loginUser.getId().equals(cartInfo.getUserId())) {
                return RestResponse.error("???????????????");
            }
            cartInfo.setNumber(number);
            if (number == 0) {
                cartService.delete(id);
            } else {
                cartService.update(cartInfo);
            }
        } else {
            return RestResponse.error("???????????????");
        }
        return RestResponse.success(getCart(loginUser));
    }

    /**
     * ????????????????????????????????????????????????????????????????????????
     */
    @PostMapping("checked")
    @ApiOperation(value = "??????????????????", notes = "????????????????????????????????????????????????????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "id", value = "1"),
                    @ExampleProperty(mediaType = "isChecked", value = "true"),
                    @ExampleProperty(mediaType = "carIds", value = "1"),
                    @ExampleProperty(mediaType = "shopsId", value = "1")
            }), required = true, dataType = "string")
    })
    @Transactional(rollbackFor = Exception.class)
    public RestResponse checked(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        String id = jsonParam.getString("id");
        JSONArray cartIds = jsonParam.getJSONArray("cartIds");
        Integer isChecked = jsonParam.getInteger("isChecked");

        if (id != null) {
            MallCartEntity cartVo = cartService.getById(id);
            if (null == cartVo) {
                return RestResponse.error("???????????????");
            }
            MallGoodsEntity entity = goodsService.getById(cartVo.getGoodsId());
            if (null == entity || entity.getIsOnSale() != 1) {
                cartVo.setChecked(0);
                cartService.update(cartVo);
                return RestResponse.error("??????????????????");
            }
            if (!loginUser.getId().equals(cartVo.getUserId())) {
                return RestResponse.error("???????????????");
            }
            cartVo.setChecked(isChecked);
            cartService.update(cartVo);
        }
        if (cartIds != null) {

            List<String> ids = new ArrayList<>();
            for (int i = 0; i < cartIds.size(); i++) {
                ids.add(cartIds.getString(i));
            }
            LambdaQueryWrapper<MallCartEntity> eq = Wrappers.<MallCartEntity>lambdaQuery()
                    .in(MallCartEntity::getId, ids);
            List<MallCartEntity> list = cartService.list(eq);

            List<MallGoodsEntity> goodsList = goodsService.list(Wrappers.<MallGoodsEntity>lambdaQuery().select(MallGoodsEntity::getId, MallGoodsEntity::getIsOnSale, MallGoodsEntity::getName)
                    .in(MallGoodsEntity::getId, list.stream().map(MallCartEntity::getGoodsId).collect(Collectors.toList())));
            Map<String, MallGoodsEntity> goodsMap = goodsList.stream().collect(Collectors.toMap(MallGoodsEntity::getId, item -> item));
            for (MallCartEntity cartVo : list) {
                MallGoodsEntity goods = goodsMap.get(cartVo.getGoodsId());
                if (goods == null) {
                    return RestResponse.error("???????????????");
                }

                if (!loginUser.getId().equals(cartVo.getUserId())) {
                    return RestResponse.error("???????????????");
                }

                if (1 != goods.getIsOnSale()) {
                    cartVo.setChecked(0);
                    cartService.update(cartVo);
                    return RestResponse.error(goods.getName() + "??????????????????");
                } else {
                    cartVo.setChecked(isChecked);
                }

                cartService.update(cartVo);
            }
        }
        return RestResponse.success(getCart(loginUser));
    }

    /**
     * ?????????????????????????????????????????????
     */
    @PostMapping("delete")
    @ApiOperation(value = "???????????????", notes = "?????????????????????????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "body", name = "jsonParam", value = "JSON????????????", examples = @Example({
                    @ExampleProperty(mediaType = "cartIds", value = "1,2,3"),
                    @ExampleProperty(mediaType = "shopsId", value = "1")
            }), required = true, dataType = "string")
    })
    public RestResponse deleteCart(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonObject) {

        String cartIds = jsonObject.getString("cartIds");
        if (StringUtils.isNullOrEmpty(cartIds)) {
            return RestResponse.error("????????????");
        }
        String[] cartIdsArray = cartIds.split(",");

        cartService.deleteBatch(cartIdsArray);

        return RestResponse.success(getCart(loginUser));
    }

    /**
     * ?????????????????????????????????
     */
    @IgnoreAuth
    @GetMapping("goodsCount")
    @ApiOperation(value = "???????????????", notes = "?????????????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "query", name = "userId", value = "??????ID", example = "1", required = true, dataType = "string")
    })
    public RestResponse goodsCount(String userId) {
        Map<String, Object> resultObj = new HashMap<>(4);
        //??????????????????
        Map<String, Object> param = new HashMap<>(2);

        if (StringUtils.isNotBlank(userId)) {
            param.put("userId", userId);
            param.put("normal", 1);

            List<MallCartEntity> cartList = cartService.queryAll(param);
            //???????????????????????????
            Integer goodsCount = 0;
            for (MallCartEntity cartItem : cartList) {
                goodsCount += cartItem.getNumber();
            }
            resultObj.put("cartList", cartList);
            resultObj.put("goodsCount", goodsCount);
        } else {
            resultObj.put("cartList", new ArrayList<>());
            resultObj.put("goodsCount", 0);
        }

        return RestResponse.success(resultObj);
    }

    /**
     * ???????????????????????????????????????????????????
     */
    @GetMapping("checkout")
    @ApiOperation(value = "????????????", notes = "???????????????????????????????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "addressId", value = "addressId", required = true, dataType = "int", example = "1"),
            @ApiImplicitParam(paramType = "query", name = "couponId", value = "couponId", dataType = "string", example = "1"),
            @ApiImplicitParam(paramType = "query", name = "type", value = "type", dataType = "string", example = "1")
    })
    @SuppressWarnings("unchecked")
    public RestResponse checkout(@LoginUser MallUserEntity loginUser, String addressId,
                                 @RequestParam(required = false) String couponId, String type) {
        Map<String, Object> resultObj = new HashMap<>(16);
        MallAddressEntity addressVo = addressService.getById(addressId);
        if (addressVo == null) {
            //??????????????????
            addressVo = addressService.getOne(new QueryWrapper<MallAddressEntity>().eq("IS_DEFAULT", 1).eq("USER_ID", loginUser.getId()), false);
            if (addressVo == null) {
                //?????????????????????????????????????????????
                addressVo = addressService.getOne(new QueryWrapper<MallAddressEntity>().eq("USER_ID", loginUser.getId()), false);
            }
        }
        resultObj.put("checkedAddress", addressVo);

        List<String> checkedGoodsIdList = new ArrayList<>();
        List<String> checkedBrandIdList = new ArrayList<>();

        // * ?????????????????????????????????
        List<MallShopsEntity> checkedShopsList = new ArrayList();
        BigDecimal goodsTotalPrice;
        Integer checkedGoodsCount = 0;

        // ??????????????????
        if (type.equals("buy")) {
            BuyGoodsVo goodsVO = (BuyGoodsVo) jedisUtil.getObject(RedisKeyConst.MTM_CACHE + "goods" + loginUser.getId());
            if (null == goodsVO) {
                return RestResponse.error("??????????????????????????????");
            }
            MallGoodsSkuEntity productInfo = goodsSkuService.getById(goodsVO.getSkuId());
            //?????????????????????
            //????????????
            goodsTotalPrice = productInfo.getRetailPrice().multiply(new BigDecimal(goodsVO.getNumber()));
            //??????????????????????????????
            MallGoodsEntity entity = goodsService.getById(goodsVO.getGoodsId());
            if (null == entity || entity.getIsOnSale() == 0) {
                return RestResponse.error("??????????????????");
            }

            checkedGoodsIdList.add(entity.getId());
            checkedBrandIdList.add(entity.getBrandId());

            MallCartEntity cartVo = new MallCartEntity();
            cartVo.setGoodsName(entity.getName());
            cartVo.setNumber(goodsVO.getNumber());
            cartVo.setRetailPrice(productInfo.getRetailPrice());
            cartVo.setGoodsId(entity.getId());
            cartVo.setListPicUrl(entity.getListPicUrl());
            cartVo.setGoodsSpecifitionNameValue(goodsVO.getSelectedText());
            cartVo.setShopsId(goodsVO.getShopsId());
            cartVo.setGoodsSn(productInfo.getGoodsSn());
            MallShopsEntity shopsEntity = mallShopsService.getById(goodsVO.getShopsId());
            cartVo.setShopsName(shopsEntity.getName());
            cartVo.setShopsSn(shopsEntity.getShopsSn());

            List<MallCartEntity> cartList = new ArrayList<>();
            cartList.add(cartVo);
            shopsEntity.setCartList(cartList);
            checkedShopsList.add(shopsEntity);

            checkedGoodsCount = goodsVO.getNumber();
        } else {
            //????????????????????????
            Map<String, Object> cartData = getCart(loginUser);
            checkedShopsList = (List<MallShopsEntity>) cartData.get("shopsCartList");
            for (MallShopsEntity shopsEntity : (List<MallShopsEntity>) cartData.get("shopsCartList")) {
                for (MallCartEntity cartEntity : shopsEntity.getCartList()) {
                    if (cartEntity.getChecked() == 1) {
                        checkedGoodsIdList.add(cartEntity.getGoodsId());
                        checkedBrandIdList.add(cartEntity.getBrandId());
                    }
                }
            }
            //?????????????????????
            //????????????
            goodsTotalPrice = (BigDecimal) ((HashMap) cartData.get("cartTotal")).get("checkedGoodsAmount");
            checkedGoodsCount = (Integer) ((HashMap) cartData.get("cartTotal")).get("checkedGoodsCount");
        }

        resultObj.put("checkedGoodsIdList", checkedGoodsIdList);
        resultObj.put("checkedBrandIdList", checkedBrandIdList);

        BigDecimal shippingFee = BigDecimal.valueOf(0);
        //????????????
        String shippingFeeFre = sysConfigService.getValue(Constant.SHIPPING_FEE_FREE, "80");
        if (goodsTotalPrice.compareTo(new BigDecimal(shippingFeeFre)) <= 0) {
            shippingFee = new BigDecimal(sysConfigService.getValue(Constant.SHIPPING_FEE, "12"));
        }
        //??????????????????
        BigDecimal sumSubPrice = new BigDecimal(0);
        //????????????
        BigDecimal subPrice = new BigDecimal(0);
        MallCouponEntity couponEntity = null;
        if (StringUtils.isNotBlank(couponId)) {
            couponEntity = couponService.getById(couponId);
            if (null != couponEntity) {
                // ???????????? >= ??????????????????
                BigDecimal minPrice = couponEntity.getMinPrice();
                if (goodsTotalPrice.compareTo(minPrice) > -1) {
                    Integer couponType = couponEntity.getCouponType();
                    //???????????????
                    if (Constant.CouponType.DJQ.getValue().equals(couponType)) {
                        subPrice = couponEntity.getSubPrice();
                    }
                    //??????
                    if (Constant.CouponType.ZK.getValue().equals(couponType)) {
                        //?????????????????????????????????1-??????/10??????????????????????????????????????????
                        subPrice = new BigDecimal(1).subtract(couponEntity.getDiscount().divide(new BigDecimal(10))).multiply(goodsTotalPrice).setScale(2, BigDecimal.ROUND_HALF_UP);
                    }
                }
            }
        }
        sumSubPrice = sumSubPrice.add(subPrice);
        resultObj.put("sumSubPrice", sumSubPrice);
        //???????????????=????????????+??????
        BigDecimal orderTotalPrice = goodsTotalPrice.add(shippingFee);
        //?????????????????????????????????????????????????????????
        BigDecimal actualPrice;
        if (orderTotalPrice.compareTo(subPrice) < 1) {
            //?????????0.01???
            if (null != couponEntity) {
                actualPrice = new BigDecimal(0.01);
            } else {
                actualPrice = orderTotalPrice.subtract(subPrice);
            }
        } else {
            actualPrice = orderTotalPrice.subtract(subPrice);
        }

        resultObj.put("shippingFee", shippingFee);
        resultObj.put("checkedGoodsList", checkedShopsList);
        resultObj.put("goodsTotalPrice", goodsTotalPrice);
        resultObj.put("orderTotalPrice", orderTotalPrice);
        resultObj.put("actualPrice", actualPrice);
        resultObj.put("checkedGoodsCount", checkedGoodsCount);
        return RestResponse.success(resultObj);
    }

    /**
     * ???????????????????????????
     */
    private RestResponse getCart(MallUserEntity loginUser) {
        //??????????????????
        Map<String, Object> param = new HashMap<>(2);
        Map<String, Object> cartTotal = new HashMap<>(8);
        List<MallShopsEntity> shopsCartList = new ArrayList<>();
        List<MallCartEntity> able = new ArrayList<>();
        List<MallCartEntity> disabled = new ArrayList<>();
        // ????????????
        if (loginUser == null) {
            return RestResponse.success().put("cartList", new ArrayList<MallCartEntity>()).put("shopsCartList", shopsCartList)
                    .put("able", able).put("disabled", disabled).put("cartTotal", cartTotal);
        } else {
            param.put("userId", loginUser.getId());
        }
        List<MallCartEntity> cartList = cartService.queryAll(param);
        //???????????????????????????
        Integer goodsCount = 0;
        BigDecimal goodsAmount = new BigDecimal(0.00);
        Integer checkedGoodsCount = 0;
        BigDecimal checkedGoodsAmount = new BigDecimal(0.00);

        // ???????????????ID
        List<String> shopsIds = new ArrayList<>();
        for (MallCartEntity cartItem : cartList) {
            goodsCount += cartItem.getNumber();
            goodsAmount = goodsAmount.add(cartItem.getRetailPrice().multiply(new BigDecimal(cartItem.getNumber())));
            if (null != cartItem.getChecked() && 1 == cartItem.getChecked() && 1 == cartItem.getIsOnSale()) {
                checkedGoodsCount += cartItem.getNumber();
                checkedGoodsAmount = checkedGoodsAmount.add(cartItem.getRetailPrice().multiply(new BigDecimal(cartItem.getNumber())));
            }
            if (cartItem.getIsOnSale() == 1) {
                able.add(cartItem);
                if (!shopsIds.contains(cartItem.getShopsId())) {
                    shopsIds.add(cartItem.getShopsId());
                }
            }
            if (cartItem.getIsOnSale() == 0) {
                disabled.add(cartItem);
            }
        }

        shopsIds.forEach(shopsId -> {
            List<MallCartEntity> cartEntities = new ArrayList<>();
            MallShopsEntity shops = new MallShopsEntity();
            able.forEach(cart -> {
                if (shopsId.equals(cart.getShopsId())) {
                    shops.setShopsSn(cart.getShopsSn());
                    shops.setId(cart.getShopsId());
                    shops.setName(cart.getShopsName());
                    cartEntities.add(cart);
                }
            });
            shops.setCartList(cartEntities);
            shopsCartList.add(shops);
        });

        cartTotal.put("goodsCount", goodsCount);
        cartTotal.put("goodsAmount", goodsAmount);
        cartTotal.put("checkedGoodsCount", checkedGoodsCount);
        cartTotal.put("checkedGoodsAmount", checkedGoodsAmount);
        return RestResponse.success().put("cartList", cartList).put("shopsCartList", shopsCartList)
                .put("able", able).put("disabled", disabled).put("cartTotal", cartTotal);
    }

    /**
     * ?????????????????????????????????????????????????????????
     */
    @GetMapping("checkoutIntegral")
    @ApiOperation(value = "??????????????????", notes = "?????????????????????????????????????????????????????????")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "header", name = "token", value = "??????token", required = true, dataType = "string"),
            @ApiImplicitParam(paramType = "query", name = "addressId", value = "addressId", required = true, dataType = "string", example = "1"),
            @ApiImplicitParam(paramType = "query", name = "goodsId", value = "addressId", required = true, dataType = "string", example = "1")
    })
    public RestResponse checkoutIntegral(@LoginUser MallUserEntity loginUser, String addressId, String goodsId) {
        Map<String, Object> resultObj = new HashMap<>(16);
        MallAddressEntity addressVo = addressService.getById(addressId);
        if (addressVo == null) {
            //??????????????????
            addressVo = addressService.getOne(new QueryWrapper<MallAddressEntity>().eq("IS_DEFAULT", 1).eq("USER_ID", loginUser.getId()), false);
            if (addressVo == null) {
                //?????????????????????????????????????????????
                addressVo = addressService.getOne(new QueryWrapper<MallAddressEntity>().eq("USER_ID", loginUser.getId()), false);
            }
        }
        resultObj.put("checkedAddress", addressVo);
        MallIntegralGoodsEntity info = integralGoodsService.getById(goodsId);

        resultObj.put("goods", info);
        return RestResponse.success(resultObj);
    }
}

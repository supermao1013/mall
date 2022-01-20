package com.platform.modules.app.controller;

import com.alibaba.fastjson.JSONObject;
import com.platform.annotation.LoginUser;
import com.platform.common.constant.RedisKeyConst;
import com.platform.common.utils.Constant;
import com.platform.common.utils.JedisUtil;
import com.platform.common.utils.RestResponse;
import com.platform.modules.app.entity.BuyGoodsVo;
import com.platform.modules.mall.entity.MallUserEntity;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author lipengjun
 * @email 939961241@qq.com
 * @gitee https://gitee.com/fuyang_lipengjun/platform
 */
@RestController
@RequestMapping("/app/buy")
@Api(tags = "AppBuyController|商品购买")
public class AppBuyController {
    @Autowired
    JedisUtil jedisUtil;

    @ApiOperation(value = "商品添加")
    @PostMapping("/add")
    public Object addBuy(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        String skuId = jsonParam.getString("skuId");
        String shopsId = jsonParam.getString("shopsId");
        String goodsId = jsonParam.getString("goodsId");
        Integer number = jsonParam.getInteger("number");
        String selectedText = jsonParam.getString("selectedText");

        BuyGoodsVo goodsVo = new BuyGoodsVo();
        goodsVo.setSkuId(skuId);
        goodsVo.setGoodsId(goodsId);
        goodsVo.setNumber(number);
        goodsVo.setShopsId(shopsId);
        goodsVo.setSelectedText(selectedText);
        jedisUtil.setObject(RedisKeyConst.MTM_CACHE + "goods" + loginUser.getId(), goodsVo);
        return RestResponse.success("添加成功");
    }

    @ApiOperation(value = "拼团商品添加")
    @PostMapping("/addGroup")
    public Object addGroup(@LoginUser MallUserEntity loginUser, @RequestBody JSONObject jsonParam) {
        String skuId = jsonParam.getString("skuId");
        String goodsId = jsonParam.getString("goodsId");
        Integer number = jsonParam.getInteger("number");
        String selectedText = jsonParam.getString("selectedText");
        String leaderId = jsonParam.getString("leaderId");
        String groupId = jsonParam.getString("groupId");
        String shopsId = jsonParam.getString("shopsId");

        BuyGoodsVo goodsVo = new BuyGoodsVo();
        goodsVo.setSkuId(skuId);
        goodsVo.setGoodsId(goodsId);
        goodsVo.setNumber(number);
        goodsVo.setSelectedText(selectedText);
        goodsVo.setLeaderId(leaderId);
        goodsVo.setGroupId(groupId);
        goodsVo.setShopsId(shopsId);
        jedisUtil.setObject(RedisKeyConst.MTM_CACHE + "group" + loginUser.getId(), goodsVo);
        return RestResponse.success("添加成功");
    }
}

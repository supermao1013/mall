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
package com.platform.modules.mall.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * 店铺实体
 *
 * @author 李鹏军
 * @since 2019-07-03 13:51:29
 */
@Data
@TableName("MALL_SHOPS")
public class MallShopsEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    /**
     * 主键
     */
    @TableId
    private String id;
    /**
     * 店铺小程序码
     */
    private String qrCode;
    /**
     * 店铺名字
     */
    private String name;
    /**
     * 店铺编码
     */
    private String shopsSn;
    /**
     * 店铺图片
     */
    private String imgUrl;
    /**
     * 店铺管理员
     */
    private String userId;
    /**
     * 营业时间
     */
    private String workTime;
    /**
     * 经度
     */
    private String longitude;
    /**
     * 纬度
     */
    private String latitude;
    /**
     * 详细位置
     */
    private String details;
    /**
     * 联系电话
     */
    private String telephone;
    /**
     * 状态 0：逻辑删除 1：正常
     */
    @TableLogic
    private Integer deleteStatus;
    /**
     * 描述
     */
    private String shopDesc;
    /**
     * 排序
     */
    private Integer sort;
    /**
     * 创建人
     */
    private String createUserId;
    /**
     * 创建时间
     */
    private Date createTime;
    /**
     * 创建人所属部门
     */
    private String createUserOrgNo;
    /**
     * 身份证
     */
    private String idCard;
    /**
     * 申请人
     */
    private String applyer;
    /**
     * 身份有效期
     */
    private String idCardValid;
    /**
     * 申请状态 1通过 0不通过
     */
    private Integer applyStatus;
    /**
     * 身份证正面
     */
    private String idCardFront;
    /**
     * 身份证反面
     */
    private String idCardReverse;
    /**
     * 审核结果描述
     */
    private String applyResultDesc;
    /**
     * 公司名称
     */
    private String companyName;
    /**
     * 营业执照
     */
    private String companyLicense;
    /**
     * 提现会员Id
     */
    private String withdrawUserId;
    /**
     * 绑定二维码
     */
    private String qrCodeBind;
    /**
     * 密码
     */
    @TableField(exist = false)
    private String password;
    /**
     * 分类名称
     */
    @TableField(exist = false)
    private String classifyName;
    /**
     * 短信码
     */
    @TableField(exist = false)
    private String smscode;

    @TableField(exist = false)
    private List<MallCartEntity> cartList;

    @TableField(exist = false)
    private String postscript;
}

<template>
	<view>
		<view class="enroll-item">
			<view class="item-title">收款人姓名</view>
			<view class="item-xing">*</view>
			<input class="item-content" type="text" placeholder="请输入姓名" v-model="name"></input>
		</view>
		<view class="enroll-item" style="margin-top: 2rpx;">
			<view class="item-title">银行卡号</view>
			<view class="item-xing">*</view>
			<input class="item-content" type="number" placeholder="请输入银行卡号" v-model="cardNumber" @blur="getUserIdCardNumber"></input>
		</view>
		<view class='enroll-item select_box' style="margin-top: 2rpx;">
			<view class="item-title">卡类型</view>
			<view class="item-xing">*</view>
			<view class='item-content select' @tap='cardTypeSelectTap'>
				<text class='select_text'>{{cardType}}</text>
			</view>
			<view class='mask' v-if="cardTypeShow" @tap='cardTypeSelectTap'></view>
			<view class='option_box' :style="'height:'+(cardTypeShow?(cardTypeList.length*70+10):0)+'rpx;'">
				<text class='option' :style='index==cardTypeList.length-1&&"border:0;"' v-for='(item, index) in cardTypeList' :key='index'
				 @tap='cardTypeOptionTap(index)'>{{item}}</text>
			</view>
		</view>
		<view class="bank-reminder">微信提现仅支持可选银行列表</view>

		<view class='enroll-item select_box' style="margin-top: 2rpx;">
			<view class="item-title">银行名称</view>
			<view class="item-xing">*</view>
			<view class='item-content select' @tap='bankTypeSelectTap'>
				<text class='select_text'>{{bankName}}</text>
			</view>
			<view class='mask' v-if="bankTypeShow" @tap='bankTypeSelectTap'></view>
			<view class='option_box' :style="'height:'+(bankTypeShow?(bankTypeList.length>10?800:bankTypeList.length*80):0)+'rpx;'">
				<text class='option' :style='index==bankTypeList.length-1&&"border:0;"' v-for='(item, index) in bankTypeList' :key='item.id'
				 @tap='bankTypeOptionTap(index)'>{{item.bankName}}</text>
			</view>
		</view>
		<!-- <view class="enroll-item" style="margin-top: 2rpx;">
		  <view class="item-title">银行名称</view>
		  <view class="item-xing">*</view>
		  <input class="item-content" type="text" placeholder="请输入支行名称" v-model="bankName"></input>
		</view> -->
		<view class="withdraw-note">提现须知</view>
		<view class="bank-reminder"></view>
		<view class="bank-reminder">请在上方填写您的真实的个人信息并与身份证信息一致，自动填充的信息请勿更改，信息出错或者不一致会导致您提现失效。我们承诺您的资料只会在本平台用户提现打款时使用不会对外使用，请放心填写。</view>
		<view class="sign-up" @tap="submitInfos">提交</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	const bindingUtil = require('@/utils/bindingUtil.js');
	export default {
		data() {
			return {
				name: '',
				cardNumber: '',
				cardType: '请选择卡类型',
				bankName: '请选择银行',
				bankId: '',
				bankTypeList: [],
				cardTypeList: [
					"储蓄卡",
					"信用卡",
					"准贷记卡",
					"预付费卡"
				],
				cardTypeShow: false,
				bankTypeShow: false
			}
		},
		onLoad: function() {
			this.getBankTypeList()
		},
		methods: {
			//银行卡号
			getUserIdCardNumber: function(e) {
				let that = this;
				if (e.detail.value == null || e.detail.value == '') {
					return
				}
				that.cardNumber = e.detail.value

				var temp = bindingUtil.bankCardAttribution(e.detail.value)
				console.log(temp)
				if (temp == Error || temp == 'error') {
					that.cardType = '请选择卡类型'
					that.bankName = '请选择银行'
					that.bankId = ''
					util.toast('查找不到相关银行信息')
				} else {
					that.cardType = temp.cardTypeName

					for (let index in that.bankTypeList) {
						let bankType = that.bankTypeList[index]
						if (bankType.bankName == temp.bankName) {
							that.bankName = bankType.bankName
							that.bankId = bankType.id
							return
						}
					};
					that.bankName = '请选择银行'
					that.bankId = ''

					util.toast('银行名称查找不到')
				}
			},
			//提交转账信息
			submitInfos: function() {
				var compare = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\d{8})$/;
				var that = this;
				if (that.name.trim().length == 0) {
					util.toast('用户名不能为空')
				} else if (!that.cardNumber) {
					util.toast('银行卡号不能为空')
				} else if (!that.cardType || that.cardType == '请选择卡类型') {
					util.toast('卡类型不能为空')
				} else if (!that.bankName || that.bankName == '请选择银行') {
					util.toast('支行名称不能为空')
				} else {
					//TODO post data to sever
					util.request('user/bindingCard', {
						cardName: that.name,
						cardNumber: that.cardNumber,
						cardType: that.cardType,
						bankTypeId: that.bankId,
					}, 'POST').then(function(res) {
						if (res.code === 0) {
							util.toast('绑定成功')
							setTimeout(function() {
								uni.navigateBack({
									delta: 1,
								})
							}, 1000)
						} else {
							util.toast(res.msg);
						}
					});
				}
			},
			getBankTypeList: function() {
				let that = this
				util.request('user/bankTypeList').then(res => {
					if (res.code === 0) {
						that.bankTypeList = res.data;
					}
				});
			},
			// 点击下拉显示框
			cardTypeSelectTap() {
				this.cardTypeShow = !this.cardTypeShow
			},
			// 点击下拉列表
			cardTypeOptionTap(Index) {
				this.cardTypeShow = !this.cardTypeShow
				this.cardType = this.cardTypeList[Index]
			},
			closeCardTypeSelect() {
				this.cardTypeShow = !this.cardTypeShow
			},
			bankTypeSelectTap() {
				this.bankTypeShow = !this.bankTypeShow
			},
			bankTypeOptionTap(Index) {
				this.bankTypeShow = !this.bankTypeShow
				this.bankName = this.bankTypeList[Index].bankName
				this.bankId = this.bankTypeList[Index].id
			}
		}
	}
</script>

<style>
	page {
		background-color: #eaeaea;
	}

	.container {
		padding: 0rpx;
	}

	.enroll-item {
		display: flex;
		flex-direction: row;
		background-color: white;
		width: 750rpx;
		height: 80rpx;
		flex-wrap: nowrap;
		align-items: center;
	}

	.item-title {
		font-size: 30rpx;
		color: #8a8a8a;
		white-space: nowrap;
		margin-left: 24rpx;
	}

	.item-xing {
		color: #fc6262;
	}

	.item-content {
		font-size: 28rpx;
		color: #8a8a8a;
		flex: 1;
		text-align: right;
		padding-right: 24rpx;
	}

	.withdraw-note {
		font-size: 30rpx;
		margin-left: 20rpx;
		margin-top: 20rpx;
		margin-bottom: 20rpx;
	}

	.bank-reminder {
		font-size: 28rpx;
		margin-left: 20rpx;
		color: #8a8a8a;
		margin-top: 10rpx;
		margin-bottom: 10rpx;
	}

	.sign-up {
		font-size: 30rpx;
		height: 96rpx;
		display: flex;
		margin-top: 24rpx;
		justify-content: center;
		align-items: center;
		background-color: #3dc2ed;
		width: 100%;
		color: white;
	}

	.select_text {
		font-size: 30rpx;
		flex: 1;
	}

	.option_box {
		border-radius: 10rpx;
		-webkit-border-radius: 10rpx;
		position: fixed;
		bottom: 0;
		width: 100%;
		border: 1px solid #efefef;
		box-sizing: border-box;
		height: 0;
		overflow-y: auto;
		border-top: 0;
		background: #fff;
		transition: height 0.3s;
		z-index: 9999;

	}

	.option {
		display: block;
		line-height: 50rpx;
		font-size: 30rpx;
		color: #8a8a8a;
		border-bottom: 1px solid #efefef;
		padding: 10rpx;
		text-align: center;
	}

	.mask {
		width: 100%;
		height: 100%;
		position: fixed;
		top: 0;
		left: 0;
		background: #000;
		z-index: 9000;
		opacity: 0.7;
	}

	/* 隐藏滚动条 */
	::-webkit-scrollbar {
		width: 0;
		height: 0;
		color: transparent;
	}
</style>

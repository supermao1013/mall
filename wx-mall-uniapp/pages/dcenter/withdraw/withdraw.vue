<template>
	<view class="dcenter-withdraw">
		<form>
			<view class="form-container">
				<text class="form-label">可提现佣金</text>
				<text class="available-amount">{{ '¥ ' + availableAmount}}</text>
			</view>
			<view class="form-container">
				<text class="form-label">提现方式</text>
				<text class="select-withdraw" @tap="withdrawSelectTap">
					<text>{{form.type == "ENT_PAY" ? "余额" : (withdrawCard.bankName+withdrawCard.cardType+"("+withdrawCard.cardNumber+")")}}</text>
				</text>
				<image src="/static/images/mall/address_right.png" class="img" @tap="withdrawSelectTap"></image>
			</view>
			<view class="form-container">
				<text class="form-label">提现金额</text>
				<input placeholder="请输入提现金额" @blur="checkAmount" v-model="form.amount" confirm-type="next" type="number"></input>
				<text class="all-text" @tap="withdrawAll">全部</text>
				<view class="alert-text">{{alertText}}</view>
			</view>
			<tui-button type="primary" shape="circle" @click="submit" class="submit-btn">提现</tui-button>
		</form>

		<view class="withdraw-select">
			<view class="mask" v-if="withdrawShow" @tap="closeWithdrawSelectTap"></view>
			<view class="option_box" :style="'height:' + (withdrawShow?260+(cardList.length>10?800:cardList.length*80):0) + 'rpx;'">
				<view class="title">选择到账方式</view>
				<view class="title-little">若提现到银行卡，会收取一定额度手续费。<text class="rule" @tap="lookRule">查看手续费收费规则</text></view>
				<text class="option" @tap="selectWithdraw('ENT_PAY')">余额</text>
				<view :style="'height:' + (withdrawShow?(cardList.length>10?800:cardList.length*80):0) + 'rpx;'">
					<text class="option" v-for="(item, index) in cardList" :key="index" @tap="selectWithdraw('PAY_BANK', item)">{{item.bankName + item.cardType + "(" + item.cardNumber + ")" }}</text>
				</view>
				<text class="option" @tap="bindingCard"><text style="font-size:38rpx;">+ </text>绑定新卡</text>
			</view>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				availableAmount: 0,
				form: {
					type: 'ENT_PAY',
					amount: '',
					cardId: '',
				},
				alertText: '',
				withdrawCard: '',
				withdrawShow: false,
				cardList: []
			}
		},
		onShow() {
			this.getDistributorInfo()
			this.getCardList()
		},
		methods: {
			getDistributorInfo() {
				let that = this
				util.request('distributor/getDistributorInfo').then(function(res) {
					that.availableAmount = res.data.mallDistEntity.amountAvailable;
				});
			},
			getCardList() {
				var that = this;
				util.request('user/getBankCard').then(function(res) {
					if (res.code === 0) {
						that.cardList = res.data
					}
				});
			},
			submit() {
				// 校验提现金额
				let legalAmount = this.checkAmount()
				if (!legalAmount) {
					return
				}
				if (this.availableAmount === 0) {
					this.alertText = '可提现金额为0'
					return
				}
				if (this.form.amount == '') {
					this.alertText = '请输入金额'
					return
				}
				console.log(this.form)
				util.request('distributor/getAmount', this.form, 'POST').then((res) => {
					uni.navigateTo({
						url: '/pages/dcenter/withdrawSuccess/withdrawSuccess?incomeTime=' + res.data.incomeTime
					})
				})
			},
			modeChange(e) {
				this.form.type = e.detail.value
			},
			checkAmount() {
				let amount = this.form.amount
				let alertText = ''
				var reg = /^\d+(\.\d{0,2})?$/;
				if (amount != '' && !reg.test(amount)) {
					alertText = '请输入有效金额'
				}
				this.alertText = alertText
				return alertText == ''
			},
			withdrawAll() {
				this.form.amount = this.availableAmount
			},
			bindingCard() {
				uni.navigateTo({
					url: '/pages/ucenter/bindingBank/bindingBank',
				})
			},
			withdrawSelectTap() {
				this.withdrawShow = true
			},
			closeWithdrawSelectTap() {
				this.withdrawShow = false
			},
			selectWithdraw(type, item) {
				if (item == null) {
					item = ''
					this.form.cardId = ''
				} else {
					this.form.cardId = item.id
				}
				this.form.type = type
				this.withdrawCard = item
				this.withdrawShow = false
			},
			lookRule() {
				uni.showModal({
					title: '手续费收费规则',
					content: '手续费收取提现金额的0.1%，最低1元，最高25元。',
					showCancel: false
				})
			}
		}
	}
</script>

<style>
	form {
		padding: 32rpx;
	}

	.form-container {
		display: flex;
		border-bottom: 2rpx solid #d7d7d7;
		padding: 24rpx 24rpx 24rpx 0;
		margin-left: 24rpx;
		align-items: center;
		position: relative;
	}

	.form-label {
		width: 192rpx;
		flex-shrink: 0;
	}

	.select-withdraw {
		position: relative;
		width: 500rpx;
	}

	.img {
		position: absolute;
		right: 20rpx;
		width: 25rpx;
		height: 25rpx;
	}

	.available-amount {
		font-weight: 400;
		color: #FB5D5D;
		font-size: 28rpx;
	}

	label {
		margin-right: 64rpx;
	}

	.alert-text {
		font-weight: 400;
		color: #FB5D5D;
		font-size: 24rpx;
		padding-left: 192rpx;
		position: absolute;
		bottom: -40rpx;
		left: 0;
	}

	.all-text {
		position: absolute;
		right: 40rpx;
		font-size: 26rpx;
		background: none;
		color: #02a7f0;
		line-height: 1;
	}

	.all-btn::after {
		border: 0;
	}

	.submit-btn {
		margin: 60rpx 0 0;
		padding: 0 60rpx;
		display: block;
		color: #008DDF;
	}


	.option_box {
		border-radius: 10rpx;
		-webkit-border-radius: 10rpx;
		overflow: hidden;
		position: fixed;
		bottom: 0;
		width: 100%;
		height: 0;
		background: #fff;
		transition: height 0.3s;
		z-index: 9000;

	}

	.title {
		width: 100%;
		display: block;
		line-height: 60rpx;
		font-size: 30rpx;
		padding-top: 10rpx;
		padding-left: 20rpx;
	}

	.title-little {
		width: 100%;
		display: block;
		line-height: 20rpx;
		font-size: 20rpx;
		color: #8a8a8a;
		border-bottom: 1px solid #efefef;
		padding-bottom: 10rpx;
		padding-left: 20rpx;
	}

	.rule {
		line-height: 20rpx;
		font-size: 20rpx;
		color: #02a7f0;
	}

	.option {
		width: 100%;
		text-align: center;
		display: block;
		line-height: 60rpx;
		font-size: 30rpx;
		border-bottom: 1px solid #efefef;
		padding: 10rpx;
	}

	.mask {
		width: 100%;
		height: 100%;
		position: fixed;
		top: 0;
		left: 0;
		background: #000;
		z-index: 8889;
		opacity: 0.7;
	}

	/* 隐藏滚动条 */
	::-webkit-scrollbar {
		width: 0;
		height: 0;
		color: transparent;
	}
</style>

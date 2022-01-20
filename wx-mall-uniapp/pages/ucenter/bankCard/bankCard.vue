<template>
	<view class="container">
		<view class="tui-header">
			<view>
				<text class="tui-title">我的卡</text>
				<text class="tui-total">（共{{cardList.length||0}}张）</text>
			</view>
			<tui-tag plain type="danger" shape="circle" hover padding="12rpx 20rpx" @click="goBinding">+ 添加银行卡</tui-tag>
		</view>
		<view class="tui-bankcard__list">
			<view :class="['tui-bankcard__item', getBankClass(item.bankName)]" v-for="(item, index) in cardList"
				:key="index" @longtap="unbinding(item.id)">
				<view class="tui-card__info">
					<view class="tui-logo__box">
						<image class="tui-logo" :src="'/static/images/mall/' + getBankClass(item.bankName) + '.png'">
						</image>
					</view>
					<view class="tui-name__box">
						<view class="tui-name">{{item.bankName}}</view>
						<view class="tui-desc">{{item.cardType}}</view>
					</view>
					<view class="tui-card__no">{{"**** **** **** "+item.cardNumber}}</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				cardList: [],
				unbindingId: ''
			}
		},
		onShow: function(options) {
			this.getCardList()
		},
		onPullDownRefresh: function() {
			this.getCardList()

			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		methods: {
			getBankClass(bankName) {
				switch (bankName) {
					case '平安银行':
						return 'tui-ping_an'
						break;
					case '中国民生银行':
						return 'tui-min_sheng'
						break;
					case '中国农业银行':
						return 'tui-nong_ye'
						break;
					case '中信银行':
						return 'tui-zhong_xin'
						break;
					case '招商银行':
						return 'tui-zhao_shang'
						break;
					case '中国建设银行':
						return 'tui-jian_she'
						break;
					case '中国工商银行':
						return 'tui-gong_shang'
						break;
					case '中国邮政储蓄银行':
						return 'tui-you_zheng'
						break;
					case '中国银行':
						return 'tui-zhong_guo'
						break;
					case '交通银行':
						return 'tui-jiao_tong'
						break;
					case '徽商银行':
						return 'tui-hui_shang'
						break;
					default:
						return 'tui-default_bank'
				}
			},
			goBinding() {
				uni.navigateTo({
					url: '/pages/ucenter/bindingBank/bindingBank',
				})
			},
			getCardList: function() {
				var that = this;
				util.request('user/getBankCard').then(function(res) {
					if (res.code === 0) {
						that.cardList = res.data
					}
				});
			},
			unbinding: function(id) {
				var that = this;
				uni.showModal({
					title: '确定取消该卡?',
					success(res) {
						if (res.confirm) {
							util.request('user/unbindingCard', {
								id: id,
							}, 'POST').then(function(res) {
								if (res.code === 0) {
									util.toast('解绑成功')
									that.getCardList()
								} else {
									util.toast(res.msg)
								}
							});
						}
					}
				})
			}
		}
	}
</script>

<style>
	.container {
		width: 100%;
		padding: 0 40rpx 40rpx;
		box-sizing: border-box;
	}

	.tui-header {
		width: 100%;
		padding: 36rpx 0;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.container {
		width: 100%;
		padding: 0 40rpx 40rpx;
		box-sizing: border-box;
	}

	.tui-header {
		width: 100%;
		padding: 36rpx 0;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.tui-title {
		font-size: 30rpx;
		font-weight: bold;
	}

	.tui-total {
		font-size: 24rpx;
		color: #999;
	}

	.tui-bankcard__item {
		width: 100%;
		height: 240rpx;
		padding: 30rpx;
		box-sizing: border-box;
		border-radius: 16rpx;
		margin-bottom: 20rpx;
	}

	.tui-logo__box {
		width: 80rpx;
		height: 80rpx;
		border-radius: 50%;
		background-color: #fff;
		display: flex;
		align-items: center;
		justify-content: center;
		margin-right: 20rpx;
	}

	.tui-logo {
		width: 52rpx;
		height: 52rpx;
	}

	.tui-card__info {
		display: flex;
		align-items: center;
		color: #fff;
	}

	.tui-name {
		font-size: 30rpx;
		font-weight: 500;
	}

	.tui-desc {
		font-size: 24rpx;
		opacity: 0.7;
	}

	.tui-card__no {
		margin-left: auto;
	}

	.tui-ping_an {
		background: linear-gradient(to right, #FEAD4B, #DE5411);
	}

	.tui-jian_she {
		background: linear-gradient(to right, #2C85D5, #003B8F);
	}

	.tui-jiao_tong {
		background: linear-gradient(to right, #2C85D5, #1D2087);
	}

	.tui-min_sheng {
		background: linear-gradient(to right, #2C87D6, #1D2087);
	}

	.tui-nong_ye {
		background: linear-gradient(to right, #01ADA3, #009174);
	}

	.tui-you_zheng {
		background: linear-gradient(to right, #01ADA3, #108C3E);
	}

	.tui-zhao_shang {
		background: linear-gradient(to right, #FF6F64, #E50012);
	}

	.tui-zhong_xin {
		background: linear-gradient(to right, #FF7065, #D7000F);
	}

	.tui-gong_shang {
		background: linear-gradient(to right, #FF7065, #E50012);
	}

	.tui-zhong_guo {
		background: linear-gradient(to right, #FF7065, #B81C22);
	}

	.tui-hui_shang {
		background: linear-gradient(to right, #FF7065, #DE0124);
	}

	.tui-default_bank {
		background: linear-gradient(to right, #FF7065, #DE0124);
	}

	.tui-title {
		font-size: 30rpx;
		font-weight: bold;
	}

	.tui-total {
		font-size: 24rpx;
		color: #999;
	}

	.tui-bankcard__item {
		width: 100%;
		height: 240rpx;
		padding: 30rpx;
		box-sizing: border-box;
		border-radius: 16rpx;
		margin-bottom: 20rpx;
	}

	.tui-logo__box {
		width: 80rpx;
		height: 80rpx;
		border-radius: 50%;
		background-color: #fff;
		display: flex;
		align-items: center;
		justify-content: center;
		margin-right: 20rpx;
	}

	.tui-logo {
		width: 52rpx;
		height: 52rpx;
	}

	.tui-card__info {
		display: flex;
		align-items: center;
		color: #fff;
	}

	.tui-name {
		font-size: 30rpx;
		font-weight: 500;
	}

	.tui-desc {
		font-size: 24rpx;
		opacity: 0.7;
	}

	.tui-card__no {
		margin-left: auto;
	}

	.tui-ping_an {
		background: linear-gradient(to right, #FEAD4B, #FF9225);
	}

	.tui-jian_she {
		background: linear-gradient(to right, #2C85D5, #2D66D1);
	}

	.tui-min_sheng {
		background: linear-gradient(to right, #2C87D6, #2D69D0);
	}

	.tui-nong_ye {
		background: linear-gradient(to right, #01ADA3, #0291A9);
	}

	.tui-zhao_shang {
		background: linear-gradient(to right, #FF6F64, #FE5762);
	}

	.tui-zhong_xin {
		background: linear-gradient(to right, #FF7065, #FD4754);
	}
</style>

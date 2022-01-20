<template>
	<view class="dcenter-index">
		<view class="card-container">
			<view class="black-card">
				<view class="white-card">
					<view class="first">
						<image class="avatar" :src="mallDistEntity.headImgUrl"></image>
						<view class="info">
							<view class="nickname">
								<text>{{ mallDistEntity.nickname }}</text>
								<tui-distributor :value="1" />
								<tui-tag type="warning" shape="circle" :scaleMultiple="0.5" v-if="!mallDistEntity.isAudit">待审</tui-tag>
							</view>
							<text class="inviter" v-if="mallDistEntity.superiorNickname">邀请人：{{ mallDistEntity.superiorNickname }}</text>
							<text class="joinTime">加入时间：{{ mallDistEntity.joinTime }}</text>
						</view>
					</view>
					<view class="value-container">
						<view class="value-block">
							<text class="value">{{ mallDistEntity.amountAvailable }}</text>
							<text class="name">可提现</text>
						</view>
						<view class="value-block">
							<text class="value">{{ mallDistEntity.amountWithdrawn }}</text>
							<text class="name">成功提现</text>
						</view>
						<view class="value-block">
							<text class="value">{{ mallDistEntity.amountTotal }}</text>
							<text class="name">累计佣金</text>
						</view>
					</view>
				</view>
				<view class="bottom-card">
					<view class="full-width flex-center" @tap="goDetail">
						<image class="icon" src="/static/images/mall/icon_detail.png" />
						<text>明细</text>
					</view>
					<view class="full-width flex-center" @tap="goWithdraw">
						<image class="icon" src="/static/images/mall/icon_withdraw.png" />
						<text>提现</text>
					</view>
				</view>
			</view>
		</view>
		<view class="menus">
			<view class="menu" @tap="goOrder">
				<image class="icon2" src="/static/images/mall/icon_daifukuan_3x.png" />
				<text class="title">分销订单</text>
				<view><text class="value">{{ orderCount }}</text><text class="unit"> 个</text></view>
			</view>
			<view class="menu" @tap="goTeam">
				<image class="icon2" src="/static/images/mall/icon_distributor.png" />
				<text class="title">我的团队</text>
				<view><text class="value">{{ teamCount }}</text><text class="unit"> 人</text></view>
			</view>
			<view class="menu" @tap="goInvitation">
				<image class="icon2" src="/static/images/mall/ic_menu_code.png" />
				<text class="title">我的二维码</text>
				<text class="subtitle">推广二维码</text>
			</view>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				mallDistEntity: {
					nickname: null,
					superiorNickname: null,
					joinTime: null,
					amountAvailable: 0,
					amountWithdrawn: 0,
					amountTotal: 0,
					headImgUrl: null,
				},
				orderCount: 0,
				teamCount: 0
			}
		},
		onShow: function() {
			this.initial();
			uni.setStorageSync("navUrl", "/pages/ucenter/index/index");
		},
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			var that = this;

			that.initial();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		methods: {
			initial: function() {
				let that = this;

				util.request('distributor/getDistributorInfo').then(function(res) {
					that.mallDistEntity = res.data.mallDistEntity
					that.teamCount = res.data.teamCount
					that.orderCount = res.data.orderCount
				});
			},
			goWithdraw() {
				uni.navigateTo({
					url: '/pages/dcenter/withdraw/withdraw'
				})
			},
			goDetail() {
				uni.navigateTo({
					url: '/pages/dcenter/detail/detail'
				})
			},
			goOrder() {
				uni.navigateTo({
					url: '/pages/dcenter/order/order'
				})
			},
			goTeam() {
				uni.navigateTo({
					url: '/pages/dcenter/team/team'
				})
			},
			goInvitation() {
				uni.navigateTo({
					url: '/pages/dcenter/invitation/invitation'
				})
			}
		}
	}
</script>

<style>
	page {
		background: #f2f2f2;
	}

	.card-container {
		padding: 64rpx 32rpx 32rpx;
	}

	.white-card {
		color: black;
		width: 100%;
		background: white;
		border-radius: 16px;
	}

	.white-card>.first {
		display: flex;
		margin-bottom: -32rpx;
		padding-top: 8rpx;
	}

	.info {
		margin-left: 64rpx;
		padding-left: 8rpx;
	}

	.info>text {
		color: #a0a0a0;
		font-size: 24rpx;
	}

	.nickname {
		display: flex;
		align-items: center;
	}

	.nickname>text {
		max-width: 250rpx;
		font-weight: 400;
		font-size: 32rpx;
	}

	.inviter {
		margin-right: 24rpx;
	}

	.avatar {
		position: relative;
		left: 48rpx;
		top: -48rpx;
		width: 128rpx;
		height: 128rpx;
	}

	.value-container {
		display: flex;
		justify-content: space-around;
		padding: 12rpx 32rpx;
	}

	.value-block {
		text-align: center;
	}

	.value-block .value {
		color: #fb5d5d;
		font-weight: 600;
		font-size: 28rpx;
	}

	.value-block .name {
		color: #a0a0a0;
		font-weight: 400;
		font-size: 28rpx;
		display: block;
	}

	.black-card {
		color: white;
		width: 100%;
		background: black;
		border-radius: 64px 64px 16px 16px;
	}

	.bottom-card {
		padding: 10rpx 0;
		display: flex;
	}

	.bottom-card text {
		font-weight: 400;
		font-size: 22rpx;
	}

	.full-width {
		width: 100%;
	}

	.flex-center {
		display: flex;
		justify-content: center;
		align-items: center;
	}

	.icon {
		width: 32rpx;
		height: 32rpx;
		margin-right: 10rpx;
	}

	.menus {
		display: flex;
		background: white;
	}

	.menu {
		display: flex;
		flex-flow: column;
		flex: 1;
		align-items: center;
		padding: 32rpx;
	}

	.menu:not(:last-of-type) {
		border-right: 1rpx solid #f2f2f2;
	}

	.icon2 {
		width: 96rpx;
		height: 96rpx;
	}

	.menus .value {
		color: #fb5d5d;
		font-weight: 400;
		font-size: 22rpx;
	}

	.menus .unit {
		font-weight: 300;
		font-size: 22rpx;
	}

	.menus .title {
		font-weight: 300;
		font-size: 28rpx;
	}

	.menus .subtitle {
		font-weight: 400;
		font-size: 22rpx;
		color: #7f7f7f;
	}
</style>

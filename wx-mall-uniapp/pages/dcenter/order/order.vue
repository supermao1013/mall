<template>
	<view class="dcenter-order">
		<!-- 导航栏 -->
		<view class="navbar">
			<block v-for="(item, index) in orderNav" :key="index">
				<view :class="'navbar-item ' + (orderType === item.type ? 'navbar-item-active' : '')" @tap="onNavBarTap(item.type)">
					<text>{{item.name}}</text>
				</view>
			</block>
		</view>
		<view class="list">
			<view v-if="orderList.length <= 0">
				<view class="no-order">
					<image src="/static/images/mall/my_course_empty.png" class="no-order-image"></image>
				</view>
				<view><text class="no-order-text">暂无订单记录</text></view>
			</view>
			<view v-for="(item, index) in orderList" :key="index" class="cell">
				<view class="cell-content">
					<view class="goods">
						<view>
							<image :src="item.goodsPic" class="img"></image>
						</view>
						<view class="right">
							<view class="title">{{item.goodsName}}</view>
							<view class="order-status">
								<text v-if="item.orderStatus == 201 || item.orderStatus == 300" class="btn" style="background-color: #4A90E2;">已付款</text>
								<text v-else-if="item.orderStatus == 301" class="btn" style="background-color:#65BA08;">已收货</text>
								<text v-else class="btn" style="background-color:#9B9B9B;">已失效</text>
							</view>
						</view>
					</view>
					<view class="order-info">
						<view class="value-block">
							<text class="value">购买者</text>
							<text class="name">{{ item.buyerNickname }}</text>
						</view>
						<view class="value-block">
							<text class="value">付款金额</text>
							<text class="name">{{ item.actualPrice }}</text>
						</view>
						<view class="value-block">
							<text class="value">结算预估收入</text>
							<text class="name">{{ item.income }}</text>
						</view>
						<view class="value-block">
							<text v-if="item.commissionType == 1" class="value">一级分销提成</text>
							<text v-else="item.commissionType == 2" class="value">二级分销提成</text>
							<text v-else="item.commissionType == 3" class="value">一级推广提成</text>
							<text v-else="item.commissionType == 4" class="value">二级推广提成</text>
							<text class="name">{{ item.commission * 100 + "%" }}</text>
						</view>
					</view>
					<view class="income-time">
						{{item.incomeTime + "付款"}}
					</view>
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
				orderType: 'ALL',
				orderNav: [{
						type: 'ALL',
						name: '全部'
					}, {
						type: 'YFK',
						name: '已付款'
					}, {
						type: 'YJS',
						name: '已结算'
					},
					{
						type: 'YSX',
						name: '已失效'
					}
				],
				orderList: [],
				current: 1,
				limit: 10,
				pages: 1
			}
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			var that = this;

			that.getOrderList();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		onReachBottom() {
			if (this.pages > this.current) {
				this.current = this.current + 1
			} else {
				return false;
			}
			this.getOrderList();
		},
		onShow: function() {
			this.initial();
		},
		methods: {
			initial: function() {
				let that = this;
				that.getOrderList();
			},
			// 获取订单列表
			getOrderList: function() {
				let that = this;
				util.request('distributor/distOrderList', {
					type: that.orderType,
					current: 1,
					limit: that.limit * that.current,
				}).then(function(res) {
					if (res.code === 0) {
						that.orderList = res.data.records
						that.pages = res.data.pages
					}
				});
			},
			onNavBarTap: function(type) {
				if (type == this.orderType) {
					return false
				}
				this.orderType = type
				this.getOrderList();
			},

		}
	}
</script>

<style>
	page {
		background: #f2f2f2;
	}

	.dcenter-order {
		display: flex;
		flex-direction: column;
	}

	.navbar {
		display: flex;
		position: absolute;
		left: 0;
		top: 0;
		z-index: 500;
		width: 100%;
		flex-direction: row;
		text-align: center;
		color: #A8A8A8;
		font-size: 15px;
		box-sizing: border-box;
		background-color: #FFF;
		border-bottom: 1rpx solid #DFDFDF;
	}

	.navbar-item {
		flex: 1;
		padding: 26rpx 0px;
	}

	.navbar-item-active {
		border-bottom: 3rpx solid #FB5D5D;
		color: #FB5D5D;
	}

	.list {
		padding-top: 50px;
	}

	.no-order {
		display: flex;
		justify-content: center;
	}

	.no-order-image {
		margin-top: 100px;
		width: 300rpx;
		height: 300rpx;
	}

	.no-order-text {
		display: flex;
		justify-content: center;
		font-size: 48rpx;
		color: #BCBCBC;
	}

	.cell {
		width: 100%;
		box-sizing: border-box;
		position: relative;
		padding: 10rpx 10rpx;
	}

	.cell-content {
		width: 100%;
		background: #fff;
		box-shadow: 0 3rpx 20rpx rgba(183, 183, 183, 0.1);
		border-radius: 10rpx;
		-webkit-border-radius: 10rpx;
		overflow: hidden;

	}

	.cell-content .goods {
		padding: 10rpx;
	}

	.cell-content .goods .img {
		margin-top: 12rpx;
		margin-right: 20rpx;
		float: left;
		width: 140rpx;
		height: 140rpx;
		border-radius: 25rpx;
	}

	.cell-content .right {
		float: left;
		height: 140rpx;
		width: 520rpx;
		flex-flow: row nowrap;
		margin-top: 12rpx;
	}

	.cell-content .right .title {
		font-size: 30rpx;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		color: #7F7F7F;
		display: block;
	}

	.order-status {
		display: block;
		padding: 40rpx 0 0 0;
	}

	.order-status .btn {
		padding: 5rpx 10rpx;
		font-size: 25rpx;
		background: #4A90E2;
		border-radius: 50rpx;
		color: #fff;
	}

	.order-info {
		float: left;
		display: -webkit-flex;
		/* Safari */
		-webkit-justify-content: space-around;
		/* Safari 6.1+ */
		display: flex;
		justify-content: space-around;
		padding: 10rpx 5rpx;
	}

	.value-block {
		width: 160rpx;
		padding: 0 10rpx;
	}

	.value-block .value {
		color: #7F7F7F;
		font-weight: 400;
		font-size: 25rpx;
	}

	.value-block .name {
		font-size: 25rpx;
		font-weight: 400;
		display: block;
		padding: 10rpx 0;
	}

	.income-time {
		font-size: 18rpx;
		color: #7f7f7f;
		font-weight: 400;
		display: block;
		padding: 10rpx;
	}
</style>

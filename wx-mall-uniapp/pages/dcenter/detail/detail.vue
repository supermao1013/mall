<template>
	<view class="dcenter-detail">
		<view class="filter">
			<tui-button class="filter-btn" plain height="64rpx" width="96rpx" :type="filter === 'ALL' ? 'primary' : 'gray'" @click="switchFilter('ALL')">
				全部
			</tui-button>
			<tui-button class="filter-btn" plain height="64rpx" width="144rpx" :type="filter === 'PROXY' ? 'primary' : 'gray'"
			 @click="switchFilter('PROXY')">
				代理提成
			</tui-button>
			<tui-button class="filter-btn" plain height="64rpx" width="144rpx" :type="filter === 'SALE' ? 'primary' : 'gray'"
			 @click="switchFilter('SALE')">
				推广提成
			</tui-button>
			<tui-button class="filter-btn" plain height="64rpx" width="144rpx" :type="filter === 'WITHDRAW' ? 'primary' : 'gray'"
			 @click="switchFilter('WITHDRAW')">
				佣金提现
			</tui-button>
		</view>
		<view class="header">
			<view>
				<text class="name">本月收益：</text>
				<text class="value">¥{{ monthIncome }}</text>
			</view>
			<view>
				<text class="name">今日收益：</text>
				<text class="value">¥{{ dayIncome }}</text>
			</view>
		</view>
		<tui-list-view class="list">
			<view v-if="incomeList.length <= 0">
				<view class="no-income">
					<image src="/static/images/mall/my_course_empty.png" class="no-income-image"></image>
				</view>
				<view><text class="no-income-text">暂无收益记录</text></view>
			</view>
			<tui-list-cell v-for="(item, index) in incomeList" :key="index" class="cell" padding="12rpx 30rpx">
				<view class="cell-content">
					<view class="info">
						<text v-if="item.type == 1">代理提成</text>
						<text v-else-if="item.type == 2">推广提成</text>
						<text v-else-if="item.type == 3">佣金提现</text>
						<!-- 待改善 -->
						<text v-if="item.income % 1 == 0">{{item.income+".00"}}</text>
						<text v-else>{{item.income}}</text>
					</view>
					<view class="info">
						<text class="time">{{ item.incomeTime }}</text>
						<text class="status">
							<!-- 提成状态 -->
							<text v-if="item.orderStatus == 201 || item.orderStatus == 300" style="color: #FB8585;">冻结中</text>
							<text v-else-if="item.orderStatus == 301" style="color: #00BFA0;">已到账</text>
							<text v-else-if="item.orderStatus > 400" style="color: #929292;">已失效</text>
							<!-- 提现状态 -->
							<text v-else-if="item.auditStatus == 0" style="color: #FB8585;">审核中</text>
							<text v-else-if="item.auditStatus == 2" style="color: #929292;">审核不通过</text>
							<text v-else-if="item.auditStatus == 1" style="color: #00BFA0;">审核通过</text>
						</text>
					</view>
				</view>
			</tui-list-cell>
		</tui-list-view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				filter: 'ALL',
				monthIncome: '0.00',
				dayIncome: '0.00',
				incomeList: [],
				current: 1,
				limit: 20,
				pages: 1
			}
		},
		onShow: function() {
			this.initial();
		},
		// 下拉刷新
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
		onReachBottom() {
			if (this.pages > this.current) {
				this.current = this.current + 1;
			} else {
				return false;
			}
			this.getIncomeList();
		},
		methods: {
			switchFilter(type) {
				this.filter = type
				this.initial()
			},
			initial: function() {
				let that = this;

				util.request('distributor/getIncomeDetails').then(function(res) {
					that.monthIncome = res.data.monthIncome
					that.dayIncome = res.data.dayIncome
				});
				that.getIncomeList();
			},
			// 获取收益列表
			getIncomeList: function() {
				let that = this;
				util.request('distributor/incomeList', {
					type: that.filter,
					current: 1,
					limit: that.limit * that.current,
				}).then(function(res) {
					if (res.code === 0) {
						that.incomeList = res.data.records
						that.pages = res.data.pages
					}
				});
			},
		}
	}
</script>

<style>
	page {
		background: #f2f2f2;
	}

	.filter {
		background: #fff;
		display: flex;
		padding: 16rpx 32rpx;
	}

	.filter-btn {
		margin-left: 16rpx;
	}

	.header {
		background: #f2f2f2;
		display: flex;
		justify-content: space-between;
		padding: 16rpx 48rpx;
	}

	.header .name {
		font-weight: 300;
		color: #7F7F7F;
		font-size: 28rpx;
	}

	.header .value {
		font-weight: 400;
		color: #FB5D5D;
		font-size: 28rpx;
	}

	.cell-content {
		width: 100%;
	}

	.info {
		display: flex;
		justify-content: space-between;
		padding-bottom: 10rpx;
	}

	.info text {
		font-weight: 400;
		font-size: 25rpx;
		color: #333333;
	}

	.info .time {
		font-size: 24rpx;
		color: #7f7f7f;
		font-weight: 400;
	}

	.info .status {
		font-size: 24rpx;
		color: #FB8585;
		font-weight: 400;
	}

	.no-income {
		display: flex;
		justify-content: center;
	}

	.no-income-image {
		margin-top: 100px;
		width: 300rpx;
		height: 300rpx;
	}

	.no-income-text {
		display: flex;
		justify-content: center;
		font-size: 48rpx;
		color: #BCBCBC;
	}
</style>

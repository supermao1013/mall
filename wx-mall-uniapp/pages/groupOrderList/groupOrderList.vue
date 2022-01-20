<template>
	<view class="container">
		<tui-tabs :tabs="tabs" isFixed :currentTab="currentTab" selectedColor="#E41F19" sliderBgColor="#E41F19"
			@change="change" itemWidth="25%"></tui-tabs>

		<view class="tui-order-list">
			<view class="tui-order-item" v-for="(item, orderIndex) in groupList" :key="orderIndex"
				@tap="detail(item.id)">
				<tui-list-cell :hover="false" :lineLeft="false">
					<view class="tui-goods-title">
						<view v-if="currentTab != 1">{{item.createTime}} {{ currentTab == 3 ? '已结束' : '已开团' }}</view>
						<view v-else class="tui-flex">
							<text>距离结束剩余</text>
							<tui-countdown :time="item.totalSecond" scale colonColor="#EB0909" borderColor="#EB0909"
								color="#EB0909"></tui-countdown>
						</view>
						<view class="tui-order-status" v-if="item.status==0">拼团失败，已退款</view>
						<view class="tui-order-status" v-if="item.status==1">待分享，差{{item.groupNumber-item.joinNumber}}人</view>
						<view class="tui-order-status" v-if="item.status==2">拼团成功</view>
					</view>
				</tui-list-cell>
				<tui-list-cell padding="0" :hover="false">
					<view class="tui-goods-item">
						<image :src="item.listPicUrl" class="tui-goods-img"></image>
						<view class="tui-goods-center">
							<view class="tui-goods-name">{{item.goodsName}}</view>
							<view class="tui-goods-attr">{{item.goodsDetail}}</view>
						</view>
						<view class="tui-price-right">
							<view>{{item.price}}</view>
							<view>x{{item.number}}</view>
						</view>
					</view>
				</tui-list-cell>
				<tui-list-cell :hover="false" unlined>
					<view class="tui-goods-price">
						<view>共{{item.number}}件商品 合计：</view>
						<view class="tui-size-24">￥</view>
						<view class="tui-price-large">{{item.orderPrice}}</view>
					</view>
				</tui-list-cell>
				<view class="tui-order-btn">
					<tui-button type="black" plain width="152rpx" height="52rpx" :size="26" shape="circle"
						@click="detail(item.id)">拼团详情
					</tui-button>
				</view>
			</view>
		</view>
		<tui-divider width="60%" gradual>没有更多了</tui-divider>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				status: '',
				groupList: [],
				tabs: [{
					name: '全部'
				}, {
					name: '拼团中'
				}, {
					name: '拼团成功'
				}, {
					name: '拼团失败'
				}],
				currentTab: 0,
				statusArr: ['', '', '拼团成功', '']
			};
		},
		onLoad() {
			this.groupData();
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			this.groupData();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		methods: {
			change(e) {
				this.currentTab = e.index;
				if (this.currentTab == 0) {
					this.status = ''
				}
				if (this.currentTab == 1) {
					this.status = '1'
				}
				if (this.currentTab == 2) {
					this.status = '2'
				}
				if (this.currentTab == 3) {
					this.status = '0'
				}
				this.groupData()
			},
			groupData() {
				let that = this
				util.request('group/list', {
					status: that.status,
					userId: uni.getStorageSync('userId') || ''
				}).then(function(res) {
					if (res.code === 0) {
						that.groupList = res.data

						that.groupList.forEach(function(group) {
							if (group.status == 1) {
								let EndTime = group.expireTime || [];
								let NowTime = new Date().getTime();
								//IOS系统直接使用new Date('2018-10-29 11:25:21')，在IOS上获取不到对应的时间对象。
								let totalSecond = Date.parse(EndTime.replace(/-/g, '/')) - NowTime || [];

								group.totalSecond = totalSecond / 1000
							}
						})
					}
				});
			},
			detail(groupId) {
				uni.navigateTo({
					url: `/pages/groupOrderDetail/groupOrderDetail?groupId=${groupId}`
				});
			}
		}
	};
</script>

<style>
	.tui-order-list {
		width: 100%;
		padding: 0 25rpx;
		margin-top: 80rpx;
		box-sizing: border-box;
	}

	.tui-order-item {
		margin-top: 20rpx;
		border-radius: 12rpx;
		box-shadow: 0 5rpx 10rpx 0 rgba(0, 0, 0, 0.06);
		overflow: hidden;
	}

	.tui-goods-title {
		width: 100%;
		font-size: 28rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.tui-flex {
		display: flex;
		align-items: center;
	}

	.tui-flex text {
		padding-right: 12rpx;
	}

	.tui-order-status {
		color: #eb0909;
		font-size: 26rpx;
	}

	.tui-goods-item {
		width: 100%;
		padding: 20rpx 30rpx;
		box-sizing: border-box;
		display: flex;
		justify-content: space-between;
	}

	.tui-goods-img {
		width: 180rpx;
		height: 180rpx;
		display: block;
		flex-shrink: 0;
	}

	.tui-goods-center {
		flex: 1;
		padding: 20rpx 8rpx;
		box-sizing: border-box;
	}

	.tui-goods-name {
		max-width: 310rpx;
		word-break: break-all;
		overflow: hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
		font-size: 26rpx;
		line-height: 32rpx;
	}

	.tui-goods-attr {
		font-size: 22rpx;
		color: #888888;
		line-height: 32rpx;
		padding-top: 20rpx;
		word-break: break-all;
		overflow: hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
	}

	.tui-price-right {
		text-align: right;
		font-size: 24rpx;
		color: #888888;
		line-height: 30rpx;
		padding-top: 20rpx;
	}

	.tui-goods-price {
		width: 100%;
		display: flex;
		align-items: flex-end;
		justify-content: flex-end;
		font-size: 24rpx;
	}

	.tui-size-24 {
		font-size: 24rpx;
		line-height: 24rpx;
	}

	.tui-price-large {
		font-size: 32rpx;
		line-height: 30rpx;
		font-weight: 500;
	}

	.tui-order-btn {
		width: 100%;
		display: flex;
		align-items: center;
		justify-content: flex-end;
		background: #fff;
		padding: 10rpx 30rpx 20rpx;
		box-sizing: border-box;
	}
</style>

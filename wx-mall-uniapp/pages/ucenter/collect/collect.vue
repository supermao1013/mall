<template>
	<view class="container">
		<tui-show-empty v-if="collectList.length<=0" text="收藏为空"></tui-show-empty>
		<view class="day-list" v-else>
			<view class="item" v-for="(item, index) in collectList" :key="index">
				<tui-swipe-action :actions="actions" @click="deleteItem(item.goodsId)">
					<view slot="content">
						<view @tap="goodsDetail(item.goodsId)">
							<image class="img" :src="item.listPicUrl"></image>
							<view class="info">
								<view class="name">{{item.goodsName}}</view>
								<view class="subtitle">{{item.goodsBrief}}</view>
								<view class="price">￥{{item.retailPrice}}</view>
							</view>
						</view>
					</view>
				</tui-swipe-action>
			</view>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				collectList: [],
				actions: [{
					name: '删除',
					color: '#fff',
					fontsize: '22',
					width: 80,
					background: '#ed3f14'
				}]
			}
		},
		onShow: function() {
			this.getCollectList();
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			this.getCollectList();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		methods: {
			getCollectList() {
				let that = this;
				util.request('user/collectList').then(function(res) {
					if (res.code === 0) {
						that.collectList = res.data
					}
				});
			},
			goodsDetail: function(goodsId) {
				uni.navigateTo({
					url: '/pages/goods/goods?id=' + goodsId,
				})
			},
			deleteItem(id) {
				let that = this;
				util.request('user/addOrDelete', {
					goodsId: id
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						that.getCollectList();
					}
				});
			}
		}
	}
</script>

<style>
	page {
		background: #f4f4f4;
		min-height: 100%;
	}

	.container {
		background: #f4f4f4;
		min-height: 100%;
	}


	.day-hd {
		height: 94rpx;
		width: 100%;
		line-height: 94rpx;
		background: #fff;
		padding-left: 30rpx;
		color: #333;
		font-size: 28rpx;
	}

	.day-list {
		height: auto;
		overflow: hidden;
		border-top: 1px solid #e1e1e1;
	}

	.item {
		margin: 10rpx;
	}

	.item .img {
		float: left;
		width: 150rpx;
		height: 150rpx;
	}

	.item .info {
		display: flex;
		flex-direction: column;
		justify-content: center;
		padding-left: 20rpx;
		padding-top: 20rpx;
	}

	.item .info .name {
		font-size: 28rpx;
		color: #333;
	}

	.item .info .subtitle {
		margin-top: 8rpx;
		font-size: 24rpx;
		color: #888;
	}

	.item .info .price {
		margin-top: 8rpx;
		font-size: 28rpx;
		color: #e41f19;
	}

	/*自定义按钮*/

	.i-swipeout-demo-button-group {
		height: 100%;
		width: 100%;
	}

	.i-swipeout-demo-button {
		width: 100px;
		float: left;
		display: flex;
		height: 100%;
		justify-content: center;
		background: #e41f19;
		color: #fff;
		align-items: center;
	}
</style>

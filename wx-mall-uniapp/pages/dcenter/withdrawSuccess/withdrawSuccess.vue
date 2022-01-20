<template>
	<view class="dcenter-withdraw">
		<view class='weui-cell-list'>
			<view class='submit'></view>
			<view class='block-submit'>
				<image class="icon-submit" src="/static/images/mall/icon_submit.png" />
				<view class='title-submit'>提现申请已提交，等待审核处理</view>
				<view class='time'>{{incomeTime}}元</view>
			</view>
		</view>
		<view class='weui-cell-list'>
			<view class='money'></view>
			<view class='block-money'>
				<image class="icon-money" src="/static/images/mall/icon_tuikuan_3x.png" />
				<view class='title-money'>到账成功</view>
			</view>
		</view>
		<tui-button type="primary" shape="circle" @click="finish" class="btn">完成</tui-button>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				incomeTime: ''
			}
		},
		onLoad: function(options) {
			this.incomeTime = options.incomeTime
		},
		methods: {
			finish() {
				uni.navigateBack({
					fail: function() {
						uni.switchTab({
							url: '/pages/index/index'
						})
					}
				})
			}
		}
	}
</script>

<style>
	.btn {
		border: 0;
		margin: 80rpx 0 0;
		display: block;
		font-size: 26rpx;
		padding: 0 100rpx;
		background: none;
		color: #008DDF;
		line-height: 1;
	}

	.weui-cell-list {
		margin: 5px 40px 5px 50px;
	}

	.block-submit {
		position: relative;
		/* width: 100px; */
		margin-left: 5rpx;
		margin-top: 80rpx;
		border-left: 4rpx solid #39A2DF;
		height: 50px;
		background: #fff
	}

	.icon-submit {
		position: absolute;
		width: 50rpx;
		height: 50rpx;
		top: -5rpx;
		left: -27rpx;
	}

	.time {
		position: absolute;
		top: 40rpx;
		left: 55rpx;
		font-size: 25rpx;
		color: #D7D7D7;
	}

	.title-submit {
		position: absolute;
		font-size: 30rpx;
		left: 55rpx;
		color: #018DDF;
	}

	.block-money {
		position: relative;
		/* width: 100px; */
		margin-left: 5rpx;
		margin-top: -10rpx;
		border-left: 4rpx solid #D7D7D7;
		height: 50px;
		background: #fff;
	}

	.icon-money {
		position: absolute;
		width: 50rpx;
		height: 50rpx;
		bottom: -5rpx;
		left: -27rpx;
	}

	.title-money {
		position: absolute;
		font-size: 30rpx;
		left: 55rpx;
		bottom: 0;
		color: #B3B9BD;
	}
</style>

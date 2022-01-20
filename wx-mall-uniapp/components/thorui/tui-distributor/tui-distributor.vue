<template>
	<view class="tui-distributor">
		<view v-if="value" class="tui-distributor-box2">
			<image src="/static/images/mall/distributor.png" class="tui-distributor-image"></image>
			<text class="tui-distributor-text">分销商</text>
		</view>
		<view v-else class="tui-distributor-box1">
			<text @tap="goDistributor" class="tui-distributor-text">成为分销商</text>
		</view>
	</view>
</template>

<script>
	export default {
		name: "tuiDistribute",
		externalClasses: ['tui-distributor-class'],
		props: {
			//是否分销商
			value: {
				type: [Number, Boolean],
				default: 0
			}
		},
		methods: {
			goDistributor: function() {
				uni.navigateTo({
					url: '/pages/dcenter/apply/apply'
				})
			}
		}
	}
</script>

<style scoped>
	.tui-distributor {
		height: 24rpx;
		margin-left: 18rpx;
		display: flex;
		align-items: center;
	}

	.tui-distributor-text {
		font-size: 20rpx;
	}

	.tui-distributor-image {
		width: 24rpx;
		height: 24rpx;
	}

	.tui-distributor-box1 {
		border: 2rpx solid #f6c846;
		border-radius: 4px;
		color: #f6c947;
		height: 24rpx;
		display: flex;
		align-items: center;
		padding: 0 10rpx;
		box-sizing: content-box;
	}

	.tui-distributor-box2 {
		color: #876624;
		background: linear-gradient(123deg, #ffffff -27%, #fcefc8 -1%, #f6c845 59%);
		border-radius: 3px;
		padding: 0 6rpx;
		/*height: 28rpx;*/
		display: flex;
		align-items: center;
		height: 100%;
	}
</style>

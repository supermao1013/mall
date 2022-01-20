<template>
	<view class="container">
		<picker @change="bindPickerChange" v-model="feedType" :range="array">
			<view class="picker">
				<view class="fb-type">
					<view class="type-label">{{array[feedType]}}</view>
					<image class="type-icon" src="/static/images/mall/icon-normal_pickerArrow.png"></image>
				</view>
			</view>
		</picker>
		<view class="fb-body">
			<textarea class="content" placeholder="对我们网站、商品、服务，你还有什么建议吗？你还希望在旗舰版上看到什么新功能？请告诉我们..." @input="contentInput"
			 :maxlength="500" :auto-focus="true" v-model="content" />
      <!-- #ifndef MP-ALIPAY -->
			<view class="text-count">{{contentLength}}/500</view>
      <!-- #endif -->
		</view>
		<view class="fb-mobile">
			<view class="label">手机号码</view>
			<view class="mobile-box">
				<input class="mobile" maxlength="11" type="number" placeholder="方便我们与你联系" v-model="mobile" />
			</view>
		</view>
		<button class="fb-btn" @tap="sbmitFeedback">提交</button>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				array: ['请选择反馈类型', '商品相关', '物流状况', '客户服务', '优惠活动', '功能异常', '产品建议', '其他'],
				feedType: 0,
				content: '',
				contentLength: 0,
				mobile: ''
			}
		},
		methods: {
			bindPickerChange: function(e) {
				this.feedType= e.detail.value;
			},
			contentInput: function(e) {
				let that = this
				that.contentLength= e.detail.cursor
				that.content= e.detail.value
			},
			sbmitFeedback: function(e) {
				let that = this;
				if (that.feedType == 0) {
					util.toast('请选择反馈类型');
					return false;
				}

				if (that.content == '') {
					util.toast('请输入反馈内容');
					return false;
				}

				if (!util.isMobile(that.mobile)) {
					util.toast('请输入正确的手机号码');
					return false;
				}
				util.request('user/saveFeedBack', {
					mobile: that.mobile,
					feedType: that.feedType,
					content: that.content
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						uni.showModal({
							content: '我们已收到您的反馈！',
							showCancel: false,
							success: function(res) {
								if (res.confirm) {
									uni.switchTab({
										url: '/pages/ucenter/index/index'
									})
								}
							}
						})
					} else {
						util.toast(res.data);
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
		padding-top: 30rpx;
	}

	.fb-type {
		height: 104rpx;
		background: #fff;
		margin-bottom: 20rpx;
		display: flex;
		flex-direction: row;
		align-items: center;
		padding-left: 30rpx;
		padding-right: 30rpx;
	}

	.fb-type .type-label {
		height: 36rpx;
		flex: 1;
		color: #333;
		font-size: 28rpx;
	}

	.fb-type .type-icon {
		height: 36rpx;
		width: 36rpx;
	}

	.fb-body {
		background: #fff;
		height: 374rpx;
		padding: 18rpx 30rpx 64rpx 30rpx;
	}

	.fb-body .content {
		height: 100%;
		color: #333;
		line-height: 40rpx;
		font-size: 28rpx;
	}

	.fb-body .text-count {
		padding-top: 17rpx;
		line-height: 30rpx;
		float: right;
		color: #666;
		font-size: 24rpx;
	}

	.fb-mobile {
		height: 162rpx;
	}

	.fb-mobile .label {
		height: 58rpx;
		padding: 30rpx 0 0 30rpx;
		color: #7f7f7f;
		font-size: 24rpx;
	}

	.fb-mobile .mobile-box {
		height: 104rpx;
		color: #333;
		padding-left: 30rpx;
		padding-right: 30rpx;
		font-size: 24rpx;
		background: #fff;
		position: relative;
	}

	.fb-mobile .mobile {
		position: absolute;
		top: 27rpx;
		left: 30rpx;
		height: 50rpx;
		color: #333;
		line-height: 50rpx;
		font-size: 24rpx;
	}

	.clear-icon {
		position: absolute;
		top: 43rpx;
		right: 30rpx;
		width: 28rpx;
		height: 28rpx;
	}

	.fb-btn {
		width: 100%;
		height: 98rpx;
		line-height: 98rpx;
		background: #e41f19;
		position: fixed;
		bottom: 0;
		left: 0;
		border-radius: 0;
		color: #fff;
		font-size: 28rpx;
	}
</style>

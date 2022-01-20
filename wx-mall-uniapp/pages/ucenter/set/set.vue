<template>
	<view class="tui-set-box">
		<tui-list-cell padding="0" :lineLeft="false" :arrow="false">
			<view class="tui-list-cell tui-info-box">
				<image :src="userInfo.headImgUrl" class="tui-avatar"></image>
				<view>{{userInfo.nickname}}</view>
			</view>
      <!-- #ifdef MP-WEIXIN -->
			<button v-if="bindPhone" class="btn-mobile" open-type="getPhoneNumber"
				@getphonenumber="getPhoneNumber">手机号授权</button>
      <!-- #endif -->
		</tui-list-cell>
		<view class="tui-mtop">
			<tui-list-cell padding="0" :lineLeft="false" :arrow="true" @click="aboutUs">
				<view class="tui-list-cell">
					关于我们
				</view>
			</tui-list-cell>
			<!-- #ifndef APP-PLUS || H5 -->
			<tui-list-cell padding="0" :lineLeft="false" :arrow="true" @click="openSetting">
				<view class="tui-list-cell">
					授权设置
				</view>
			</tui-list-cell>
			<!-- #endif -->
      <tui-list-cell padding="0" :lineLeft="false" :arrow="true" @click="jump(1)">
        <view class="tui-list-cell">
          用户协议
        </view>
      </tui-list-cell>
      <tui-list-cell padding="0" :lineLeft="false" :arrow="true" @click="jump(2)">
        <view class="tui-list-cell">
          隐私协议
        </view>
      </tui-list-cell>
		</view>

		<view class="tui-exit">
			<tui-button type="danger" @click="exit" height="88rpx">退出登录</tui-button>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	const app = getApp()
	export default {
		data() {
			return {
				userInfo: {},
				bindPhone: true
			}
		},
		onLoad: function(options) {
			let that = this;
			util.request('user/userInfo').then(function(res) {
        if (res.code === 0) {
          if (res.data.mobile) {
            that.bindPhone = false;
          }
          that.userInfo = res.data;
        }
			});
		},
		methods: {
      jump(id) {
        uni.navigateTo({
          url: '/pages/auth/richtext/richtext?id=' + id
        })
      },
			getPhoneNumber(e) {
				if (e.detail.errMsg === 'getPhoneNumber:ok') {
					uni.login({
						success: function(r) {
							let code = r.code; //登录凭证
							util.request("auth/LoginByMaPhone", {
								userId: uni.getStorageSync('userId'),
								code: code,
								userInfo: e.detail
							}, 'POST', 'application/json').then(res => {
								if (res.code === 0) {
									uni.switchTab({
										url: '/pages/ucenter/index/index',
									})
								} else {
									util.toast('请重新授权')
								}
							}).catch(ex => {
								console.log(ex, "ex")
							});
						}
					})
				} else {
					uni.showModal({
						title: '提示',
						showCancel: false,
						content: '为了获得更好的服务，请允许授权'
					})
				}
			},
			openSetting: function() {
				uni.openSetting()
			},
			aboutUs: function() {
				uni.navigateTo({
					url: '/pages/ucenter/about/about',
				})
			},
			exit: function() {
				app.globalData.userInfo = {
					nickname: 'Hi,游客,点击头像登录',
					headImgUrl: '/static/images/mall/mine_def_touxiang_3x.png'
				}
				uni.clearStorage({
					success() {
						util.toast('退出成功');
						setTimeout(function() {
							uni.reLaunch({
								url: '/pages/ucenter/index/index',
							})
						}, 1000)
					}
				})
			}
		}
	}
</script>

<style>
	.tui-set-box {
		padding-bottom: 20rpx;
		color: #333;
	}

	.tui-list-cell {
		display: flex;
		align-items: center;
		padding: 24rpx 30rpx;
		font-size: 30rpx;
	}

	.tui-info-box {
		font-size: 34rpx;
	}

	.tui-avatar {
		width: 140rpx;
		height: 140rpx;
		margin-right: 20rpx;
	}

	.tui-mtop {
		margin-top: 20rpx;
	}

	.tui-exit {
		padding: 50rpx 50rpx;
	}

	.btn-mobile {
		background: #04be02 !important;
		color: white;
		font-size: 20rpx;
	}
</style>

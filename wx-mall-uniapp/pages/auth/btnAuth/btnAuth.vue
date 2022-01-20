<template>
	<view class="page">
		<view class="hd">
			<image class="logo" src="/static/images/mall/logo.png"></image>
			<view class="title">安徽微同科技有限公司欢迎你!</view>
		</view>
		<view class="btns">
      <!-- #ifdef H5 -->
			<button class="btn btn_zhuce" v-if="!isMp" @tap="goRegister">会员注册
			</button>
      <!-- #endif -->
			<!-- #ifdef APP-PLUS -->
			<button v-if="isIphone" class="btn btn_apple" @tap="appleLogin">
				<tui-icon name="ios" color="#fff" :size="16"></tui-icon>通过Apple登录
			</button>
			<!-- #endif -->
			<!-- 头条登录 -->
			<!-- #ifdef MP-TOUTIAO -->
			<button class="btn btn_apple" @tap="getuserinfott">
				<tui-icon name="applets" color="#fff" :size="16"></tui-icon>头条登录
			</button>
			<!-- #endif -->
			<!-- 需要使用 button 来授权登录 -->
			<!-- #ifdef MP-WEIXIN -->
			<button class="btn btn_primary" v-if="canIUseGetUserProfile&&!phoneVisible" @tap="getUserProfile"> 微信登录
			</button>
			<button class="btn btn_primary" v-if="!canIUseGetUserProfile&&!phoneVisible" open-type="getUserInfo"
				@getuserinfo="bindGetUserInfo"> 微信登录
			</button>
			<button class="btn btn_primary" v-if="phoneVisible" open-type="getPhoneNumber"
				@getphonenumber="getPhoneNumber">手机号授权</button>
			<!-- #endif -->
			<!-- #ifdef APP-PLUS -->
			<button class="btn btn_primary" v-if="existWx" @tap="wxLogin">
				<tui-icon name="wechat" color="#fff" :size="16"></tui-icon>微信登录
			</button>
			<!-- #endif -->
			<!-- #ifdef MP-ALIPAY -->
			<button class="btn btn_alipay" @tap="aliLogin">
				<tui-icon name="alipay" color="#fff" :size="16"></tui-icon>支付宝登录
			</button>
			<!-- #endif -->
			<button class="btn btn_primary" v-if="isMp" @tap="mpLogin">
				<tui-icon name="wechat" color="#fff" :size="16"></tui-icon>微信登录
			</button>
			<button class="btn btn_default" v-if="!phoneVisible" shape="circle" width="500rpx" height="100rpx"
				:size="26" @tap="goLogin">
				<tui-icon name="mobile" color="#fff" :size="16"></tui-icon>手机登录
			</button>
			<button class="btn btn_grey" v-if="!phoneVisible" shape="circle" width="500rpx" height="100rpx" :size="26"
				@tap="noLogin">
				<tui-icon name="home" color="#fff" :size="16"></tui-icon>返回首页
			</button>
		</view>
		<view class="tip-box" v-if="!phoneVisible">
			<label class="xieyi">
				<checkbox-group @change="onTcp">
					<checkbox class="tcp-radio brown"></checkbox>
				</checkbox-group>
				<view>我已阅读并遵守</view>
				<text class="tcp" @tap="jump(1)">《用户协议》</text>
				与
				<text class="tcp" @tap="jump(2)">《隐私协议》</text>
			</label>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js");
	let app = getApp();
	export default {
		data() {
			return {
				canIUseGetUserProfile: false,
				phoneVisible: false,
				navUrl: '',
				code: '',
				isTcp: false, //协议
				isIphone: util.isIphone(),
				existWx: false,
				isMp: false
			}
		},
		methods: {
			goRegister() {
				let that = this;
				if (!that.checkIsTcp()) {
					return
				}
				uni.navigateTo({
					url: '/pages/auth/register/register'
				})
			},
			jump(id) {
				uni.navigateTo({
					url: '/pages/auth/richtext/richtext?id=' + id
				})
			},
			onTcp() {
				this.isTcp = !this.isTcp;
			},
			checkIsTcp: function() {
				if (!this.isTcp) {
					util.toast('请先同意协议')
					return false
				}
				return true;
			},
			getuserinfott: function() {
				let that = this;
				if (!that.checkIsTcp()) {
					return
				}
				uni.login({
					provider: 'toutiao',
					success(loginRes) {
						console.log(`login 调用成功` + JSON.stringify(loginRes));
						uni.getUserInfo({
							withCredentials: true,
							success(res) {
								console.log(`getUserInfo 调用成功` + JSON.stringify(res));

								util.request('auth/LoginByTT', {
									code: loginRes.code,
									anonymousCode: loginRes.anonymousCode,
									userInfo: res
								}, 'POST', 'application/json').then(res => {
									if (res.code === 0) {
										//存储用户信息
										uni.setStorageSync('userInfo', res.userInfo);
										uni.setStorageSync('token', res.token);
										uni.setStorageSync('userId', res.userId);
									} else {
										util.toast(res.msg)
									}

									if (that.navUrl == '/pages/index/index' || that.navUrl ==
										'/pages/ucenter/index/index' || that.navUrl ==
										'/pages/cart/cart') {
										uni.reLaunch({
											url: that.navUrl
										})
									} else if (that.navUrl) {
										uni.redirectTo({
											url: that.navUrl
										})
									}
								});
							},
							fail(res) {
								console.log(`getUserInfo 调用失败` + JSON.stringify(res));
							},
						});
					}
				});
			},
			getUserProfile() {
				let that = this;
				if (!that.checkIsTcp()) {
					return
				}
				// 推荐使用uni.getUserProfile获取用户信息，开发者每次通过该接口获取用户个人信息均需用户确认
				// 开发者妥善保管用户快速填写的头像昵称，避免重复弹窗
				uni.getUserProfile({
					desc: '用于完善会员资料', // 声明获取用户个人信息后的用途，后续会展示在弹窗中，请谨慎填写
					success: (res) => {
						//登录远程服务器
						if (that.code) {
							that.LoginByMa(res)
						} else {
							uni.login({
								success: function(resp) {
									if (resp.code) {
										that.code = resp.code
										that.LoginByMa(res)
									}
								}
							});
						}
					}
				})
			},
			bindGetUserInfo: function(e) {
				let that = this;
				if (!that.checkIsTcp()) {
					return
				}
				if (e.detail.errMsg.indexOf("fail auth deny") > -1) {
					uni.showModal({
						title: '提示',
						content: '用户拒绝',
						showCancel: false,
						success(res) {
							if (res.confirm) {
								uni.switchTab({
									url: '/pages/index/index'
								})
							}
						}
					});
				} else {
					uni.login({
						success: function(res) {
							if (res.code) {
								that.code = res.code
								that.LoginByMa(e.detail, 1)
							}
						}
					});
				}
			},
			mpLogin() {
				let that = this;
				if (!that.checkIsTcp()) {
					return
				}
				window.location.replace(
					"https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + util.mpAppId +
					"&redirect_uri=" + encodeURIComponent(util.domain + 'h5/#/pages/auth/btnAuth/btnAuth') +
					"&response_type=code&scope=snsapi_base&state=1#wechat_redirect"
				);
			},
			aliLogin() {
				let that = this;
				if (!that.checkIsTcp()) {
					return
				}
				// #ifdef MP-ALIPAY
				my.getAuthCode({
					scopes: ['auth_user', 'auth_base'],
					// 主动授权：auth_user，静默授权：auth_base或者其它scope。如需同时获取用户多项授权，可在 scopes 中传入多个 scope 值。
					success: (res) => {
						if (res.authCode) {
							that.LoginByMa(res, 3)
						}
					}
				});
				// #endif
			},
			wxLogin() {
				let that = this;
				if (!that.checkIsTcp()) {
					return
				}
				uni.login({
					provider: 'weixin',
					success: function(res) {
						that.LoginByMa(res.authResult, 2)
					}
				});
			},
			appleLogin() {
				let that = this;
				if (!that.checkIsTcp()) {
					return
				}
				uni.login({
					provider: 'apple',
					success: function(loginRes) {
						// 登录成功
						uni.getUserInfo({
							provider: 'apple',
							success(res) {
								console.log(res)
								util.request('auth/AppleLogin', {
									userInfo: res.userInfo
								}, 'POST', 'application/json').then(res => {
									if (res.code === 0) {
										//存储用户信息
										uni.setStorageSync('userInfo', res.userInfo);
										uni.setStorageSync('token', res.token);
										uni.setStorageSync('userId', res.userId);
									} else {
										util.toast(res.msg)
									}

									if (that.navUrl && (that.navUrl == '/pages/index/index' ||
											that.navUrl ==
											'/pages/ucenter/index/index' || that.navUrl ==
											'/pages/cart/cart')) {
										uni.switchTab({
											url: that.navUrl
										})
									} else if (that.navUrl) {
										uni.redirectTo({
											url: that.navUrl
										})
									}
								});
							}
						})
					},
					fail: function(err) {
						util.toast('登录失败：' + err)
					}
				});
			},
			LoginByMa(userInfo, type) {
				let that = this;
				let url = 'auth/LoginByMa'
				// APP端微信登录
				if (type == 2) {
					url = 'auth/AppLoginByWx'
				}
				if (type == 3) {
					url = 'auth/LoginByAli'
					that.code = userInfo.authCode
				}
				util.request(url, {
					code: that.code,
					userInfo: userInfo
				}, 'POST', 'application/json').then(res => {
					if (res.code === 0) {
						//存储用户信息
						uni.setStorageSync('userInfo', res.userInfo);
						uni.setStorageSync('token', res.token);
						uni.setStorageSync('userId', res.userId);
						if (type == 2 || type == 3) {
							if (that.navUrl && (that.navUrl == '/pages/index/index' || that.navUrl ==
									'/pages/ucenter/index/index' || that.navUrl == '/pages/cart/cart')) {
								uni.switchTab({
									url: that.navUrl
								})
							} else if (that.navUrl) {
								uni.redirectTo({
									url: that.navUrl,
								})
							}
						}
						// #ifdef MP-WEIXIN
						if (res.userInfo.mobile) {
							if (that.navUrl && (that.navUrl == '/pages/index/index' || that.navUrl ==
									'/pages/ucenter/index/index' || that.navUrl == '/pages/cart/cart')) {
								uni.switchTab({
									url: that.navUrl
								})
							} else if (that.navUrl) {
								uni.redirectTo({
									url: that.navUrl,
								})
							}
						} else {
							that.phoneVisible = true
						}
						// #endif
					} else {
						util.toast(res.msg)
					}
				});
				this.code = ''
			},
			getPhoneNumber(e) {
				let that = this;
				if (e.detail.errMsg === 'getPhoneNumber:ok') {
					uni.login({
						success: function(r) {
							let code = r.code;
							util.request("auth/LoginByMaPhone", {
								userId: uni.getStorageSync('userId'),
								code: code,
								userInfo: e.detail
							}, 'POST', 'application/json').then(res => {
								if (res.code === 0) {
									if (that.navUrl && (that.navUrl == '/pages/index/index' ||
											that.navUrl == '/pages/ucenter/index/index' ||
											that.navUrl == '/pages/cart/cart')) {
										uni.switchTab({
											url: that.navUrl
										})
									} else if (that.navUrl) {
										uni.redirectTo({
											url: that.navUrl
										})
									}
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
			noLogin: function() {
				uni.switchTab({
					url: '/pages/index/index'
				})
			},
			goLogin: function() {
				let that = this;
				if (!that.checkIsTcp()) {
					return
				}
				uni.navigateTo({
					url: '/pages/auth/login/login',
				})
			},
			getQueryString: function(name) {
				var result = window.location.href.match(new RegExp("[\?\&]" + name +
					"=([^\&]+)", "i"));
				if (result == null || result.length < 1) {
					return "";
				}
				return result[1];
			}
		},
		onLoad: function(options) {
			let that = this;
			// #ifdef APP-PLUS
			that.existWx = util.existWx();
			// #endif
			if (uni.getStorageSync("navUrl")) {
				that.navUrl = uni.getStorageSync('navUrl')
			} else {
				that.navUrl = '/pages/index/index'
			}
			uni.removeStorageSync('navUrl');
			// #ifdef MP-WEIXIN
			if (uni.getUserProfile) {
				that.canIUseGetUserProfile = true
			}
			uni.login({
				success: function(res) {
					if (res.code) {
						that.code = res.code
					}
				}
			});
			// #endif
			// #ifdef H5
			if (util.isWeChat()) {
				that.isMp = true;
				var mpCode = that.getQueryString("code");
				if (mpCode) {
					util.request('auth/loginByMp', {
						mpAppId: util.mpAppId,
						code: mpCode
					}, 'POST', 'application/json').then(res => {
						if (res.code === 0) {
							//存储用户信息
							uni.setStorageSync('userInfo', res.userInfo);
							uni.setStorageSync('token', res.token);
							uni.setStorageSync('userId', res.userInfo.id);
						} else {
							util.toast(res.msg)
						}

						if (that.navUrl && (that.navUrl == '/pages/index/index' || that.navUrl ==
								'/pages/ucenter/index/index' || that.navUrl == '/pages/cart/cart')) {
							uni.switchTab({
								url: that.navUrl,
							})
						} else if (that.navUrl) {
							uni.redirectTo({
								url: that.navUrl,
							})
						}
					});
				}
			}
			// #endif
		}
	}
</script>

<style>
	.hd {
		display: flex;
		width: 100%;
		flex-direction: column;
		align-items: center;
		justify-content: center;
	}

	.hd .logo {
		width: 260rpx;
		height: 260rpx;
		margin-top: 40rpx;
	}

	.hd .title {
		text-align: center;
		font-size: 36rpx;
		color: #000;
	}

	.btns {
		margin-top: 300rpx;
	}

	.btn {
		margin: 10rpx auto;
	}

	.btn_zhuce {
		width: 500rpx;
		background-color: #262B3A;
		line-height: 100rpx;
		font-size: 26rpx;
		border-radius: 50rpx;
		color: #fff;
	}

	.btn_apple {
		width: 500rpx;
		background-color: #000;
		line-height: 100rpx;
		font-size: 26rpx;
		border-radius: 50rpx;
		color: #fff;
	}

	.btn_alipay {
		width: 500rpx;
		background-color: #1890FF;
		line-height: 100rpx;
		font-size: 26rpx;
		border-radius: 50rpx;
		color: #fff;
	}

	.btn_primary {
		width: 500rpx;
		background-color: #04be02;
		line-height: 100rpx;
		font-size: 26rpx;
		border-radius: 50rpx;
		color: #fff;
	}

	.btn_default {
		width: 500rpx;
		background-color: #e41f19;
		line-height: 100rpx;
		font-size: 26rpx;
		border-radius: 50rpx;
		color: #fff;
	}

	.btn_grey {
		width: 500rpx;
		background-color: grey;
		line-height: 100rpx;
		font-size: 26rpx;
		border-radius: 50rpx;
		color: #fff;
	}

	.tip-box {
		margin-top: 40rpx;
		width: 100%;
		line-height: 108rpx;
		font-size: 24rpx;
		font-weight: 400;
		color: rgba(200, 150, 61, 1);
	}

	.tip-box .tcp-radio {
		transform: scale(0.6);
	}

	.tip-box .tcp {
		text-decoration: underline;
	}

	.tip-box .xieyi {
		display: flex;
		align-items: center;
		justify-content: center;
	}
</style>

<script>
	const util = require("@/utils/util.js")
	export default {
		globalData: {
			share: false, // 分享默认为false
			referrerUserId: '', //分享的用户Id
			customBar: {
				width: 0,
				height: 0,
				top: 0,
				scrollH: 0
			},
			userInfo: {
				nickname: 'Hi,游客,点击头像登录',
				headImgUrl: '/static/images/mall/mine_def_touxiang_3x.png'
			},
			token: '',
			rechargeStatus: 2
		},
		onLaunch: function(options) {
			let that = this;
			let obj = {
				top: 0,
				left: 0,
				height: 0
			}
			// #ifdef MP-WEIXIN
			//获取设备顶部窗口的高度（不同设备窗口高度不一样，根据这个来设置自定义导航栏的高度）
			obj = uni.getMenuButtonBoundingClientRect();
			if (options.scene == 1007 || options.scene == 1008) {
				this.globalData.share = true
			} else {
				this.globalData.share = false
			}
			if (uni.canIUse('getUpdateManager')) {
				const updateManager = uni.getUpdateManager();
				if (updateManager) {
					updateManager.onCheckForUpdate(function(res) {
						// 请求完新版本信息的回调
						if (res.hasUpdate) {
							updateManager.onUpdateReady(function() {
								util.modal('更新提示', '新版本已经上线啦~，为了获得更好的体验，建议立即更新', false, res => {
									// 新的版本已经下载好，调用 applyUpdate 应用新版本并重启
									updateManager.applyUpdate();
								});
							});
							updateManager.onUpdateFailed(function() {
								// 新的版本下载失败
								util.modal('更新失败', '新版本更新失败，为了获得更好的体验，请您删除当前小程序，重新搜索打开', false, res => {});
							});
						}
					});
				}
			}
			// #endif
			uni.getSystemInfo({
				success: (res) => {
					that.globalData.customBar.width = obj.left || res.windowWidth
					that.globalData.customBar.height = obj.top ? (obj.top + obj.height + 8) : (res.statusBarHeight + 44)
					that.globalData.customBar.top = obj.top ? (obj.top + (obj.height - 32) / 2) : (res.statusBarHeight + 6)
					that.globalData.customBar.scrollH = res.windowWidth * 0.6
				}
			})

			util.request('index/getRechargeStatus').then(res => {
				if (res.code === 0) {
					that.globalData.rechargeStatus = res.rechargeStatus
				}
			});
		},
		onShow: function() {

		},
		onHide: function() {
			//console.log('App Hide')
		},
		onError: function(err) {
			//全局错误监听
			// #ifdef APP-PLUS
			plus.runtime.getProperty(plus.runtime.appid, widgetInfo => {
				const res = uni.getSystemInfoSync();
				let errMsg = `手机品牌：${res.brand}；手机型号：${res.model}；操作系统版本：${res.system}；客户端平台：${res.platform}；错误描述：${err}`;
				console.log('发生错误：' + errMsg);
			});
			// #endif
		}
	};
</script>

<style>
	/*每个页面公共css uParse为优化版本*/
	@import './common/app.css';
	/* #ifndef APP-NVUE */
	@import './components/uni/uParse/src/wxParse.css';
	/* #endif */
</style>

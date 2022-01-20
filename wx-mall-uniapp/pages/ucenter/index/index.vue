<template>
	<view>
    <!-- #ifndef MP-ALIPAY -->
		<!--header-->
		<view class="tui-header-box" :style="{ height: height + 'px', background: 'rgba(255,255,255,' + opcity + ')' }">
			<view class="tui-header" :style="{ paddingTop: top + 'px', opacity: opcity }">我的</view>
		</view>
		<!--header-->
    <!-- #endif -->

		<view class="tui-mybg-box">
			<image src="/static/images/mall/img_bg_3x.png" class="tui-my-bg" mode="widthFix"></image>
			<view class="tui-header-center">
				<image :src="curUser.headImgUrl||'/static/images/mall/mine_def_touxiang_3x.png'" class="tui-avatar" @tap="goLogin"></image>
				<view class="tui-info">
					<view class="tui-nickname">
						<text class="nickname">{{curUser.nickname||'Hi,游客,点击头像登录'}}</text>
						<image v-if="curUser.userLevelName" :src="'/static/images/mall/'+curUser.userLevelName+'.png'" class="tui-img-vip"></image>
						<tui-distributor v-if="distributionStatus==1&&curUser.nickname" :value="curUser.isDistributor"></tui-distributor>
					</view>
				</view>
				<view class="tui-set-box">
					<view class="tui-icon-box tui-icon-setup" @tap="setting">
						<tui-icon name="setup" color="#fff" :size="26"></tui-icon>
					</view>
				</view>
			</view>
			<view class="tui-header-btm">
				<view class="tui-btm-item" @tap="goAsset" data-type="1">
					<view class="tui-btm-num">{{curUser.balance||0}}</view>
					<view class="tui-btm-text">账户余额</view>
				</view>
				<view class="tui-btm-item" @tap="goAsset" data-type="2">
					<view class="tui-btm-num">{{curUser.integral||0}}</view>
					<view class="tui-btm-text">我的积分</view>
				</view>
				<view class="tui-btm-item" @tap="goAsset" data-type="3">
					<view class="tui-btm-num">{{couponCount||0}}</view>
					<view class="tui-btm-text">优惠券</view>
				</view>
			</view>
		</view>
		<view class="tui-content-box">
			<view class="tui-box tui-order-box">
				<tui-list-cell :arrow="true" padding="0" :lineLeft="false">
					<view class="tui-cell-header" @tap="orderList" data-type="0">
						<view class="tui-cell-title">我的订单</view>
						<view class="tui-cell-sub">查看全部订单</view>
					</view>
				</tui-list-cell>
				<view class="tui-order-list">
					<view class="tui-order-item" @tap="orderList" data-type="1">
						<view class="tui-icon-box">
							<image src="/static/images/mall/icon_daifukuan_3x.png" class="tui-order-icon"></image>
							<view class="tui-badge tui-badge-red" v-if="unPayNum>0">{{unPayNum}}</view>
						</view>
						<view class="tui-order-text">待付款</view>
					</view>
					<view class="tui-order-item" @tap="orderList" data-type="2">
						<view class="tui-icon-box">
							<image src="/static/images/mall/icon_daifahuo_3x.png" class="tui-order-icon"></image>
							<view class="tui-badge tui-badge-red" v-if="unSendNum>0">{{unSendNum}}</view>
						</view>
						<view class="tui-order-text">待发货</view>
					</view>
					<view class="tui-order-item" @tap="orderList" data-type="3">
						<view class="tui-icon-box">
							<image src="/static/images/mall/icon_daishouhuo_3x.png" class="tui-order-icon"></image>
							<view class="tui-badge tui-badge-red" v-if="unTakeNum>0">{{unTakeNum}}</view>
						</view>
						<view class="tui-order-text">待收货</view>
					</view>
					<view class="tui-order-item" @tap="orderList" data-type="4">
						<view class="tui-icon-box">
							<image src="/static/images/mall/icon_pingjia_3x.png" class="tui-order-icon"></image>
							<view class="tui-badge tui-badge-red" v-if="unEvalNum>0">{{unEvalNum}}</view>
						</view>
						<view class="tui-order-text">待评价</view>
					</view>
					<view class="tui-order-item" @tap="orderList" data-type="5">
						<view class="tui-icon-box">
							<image src="/static/images/mall/icon_tuikuan_3x.png" class="tui-order-icon"></image>
              <view class="tui-badge tui-badge-red" v-if="shNum>0">{{shNum}}</view>
						</view>
						<view class="tui-order-text">退款/售后</view>
					</view>
				</view>
			</view>
			<view class="tui-box tui-tool-box">
				<tui-list-cell :arrow="false" padding="0" :lineLeft="false">
					<view class="tui-cell-header">
						<view class="tui-cell-title">常用工具</view>
					</view>
				</tui-list-cell>
				<view class="tui-order-list tui-flex-wrap">
					<view v-if="distributionStatus==1" class="tui-tool-item" @tap="goAsset" data-type="11">
						<view class="tui-icon-box">
							<image src="/static/images/mall/icon_distributor.png" class="tui-tool-icon"></image>
						</view>
						<view class="tui-tool-text">分销中心</view>
					</view>
          <view class="tui-tool-item" @tap="goAsset" data-type="13">
            <view class="tui-icon-box">
              <image src="/static/images/mall/icon_withdraw.png" class="tui-tool-icon"></image>
            </view>
            <view class="tui-tool-text">我的拼团</view>
          </view>
					<view class="tui-tool-item" @tap="payFace">
						<view class="tui-icon-box">
							<image src="/static/images/mall/facetoface.png" class="tui-tool-icon"></image>
						</view>
						<view class="tui-tool-text">当面付</view>
					</view>
          <view class="tui-tool-item" @tap="goAsset" data-type="2">
						<view class="tui-icon-box">
							<image src="/static/images/mall/icon_gift_3x.png" class="tui-tool-icon"></image>
						</view>
						<view class="tui-tool-text">签到领好礼</view>
					</view>
					<view class="tui-tool-item" @tap="goAsset" data-type="4">
						<view class="tui-icon-box">
							<image src="/static/images/mall/icon_miaosha.png" class="tui-tool-icon"></image>
						</view>
						<view class="tui-tool-text">我的秒杀</view>
					</view>
					<view class=" tui-tool-item" @tap="goAsset" data-type="5">
						<view class="tui-icon-box">
							<image src="/static/images/mall/icon_collect_checked.png" class="tui-tool-icon"></image>
						</view>
						<view class="tui-tool-text">我的收藏</view>
					</view>
					<view class=" tui-tool-item" @tap="goAsset" data-type="6">
						<view class="tui-icon-box">
							<image src="/static/images/mall/icon_footprint.png" class="tui-tool-icon"></image>
						</view>
						<view class="tui-tool-text">我的足迹</view>
					</view>
					<view class=" tui-tool-item" @tap="goAsset" data-type="7">
						<view class="tui-icon-box">
							<image src="/static/images/mall/icon_address.png" class="tui-tool-icon"></image>
						</view>
						<view class="tui-tool-text">地址管理</view>
					</view>
					<view class=" tui-tool-item" @tap="goAsset" data-type="8">
						<view class="tui-icon-box">
							<image src="/static/images/mall/icon_feedback.png" class="tui-tool-icon"></image>
						</view>
						<view class="tui-tool-text">意见反馈</view>
					</view>
					<view class="tui-tool-item" @tap="goAsset" data-type="9">
						<view class="tui-icon-box">
							<image src="/static/images/mall/icon_kefu_3x.png" class="tui-tool-icon"></image>
						</view>
						<navigator class="tui-tool-text" url="/pages/ucenter/kefu/kefu">联系客服</navigator>
					</view>
				</view>
			</view>

			<!--为你推荐-->
			<tui-divider :size="28" :bold="true" color="#333" v-if="newGoods.length>0" width="50%">为你推荐</tui-divider>
			<view class="tui-product-list">
				<view class="tui-product-container">
					<block v-for="(item, index) in newGoods" :key="index" v-if="(index+1)%2!=0">
						<!--商品列表-->
						<view class="tui-pro-item" hover-class="hover" :hover-start-time="150" @tap="goodsDetail(item.id)">
							<image :src="item.listPicUrl" class="tui-pro-img" mode="widthFix" />
							<view class="tui-pro-content">
								<view class="tui-pro-tit">{{item.goodsName||''}}</view>
								<view>
									<view class="tui-pro-price">
										<text class="tui-sale-price">￥{{item.retailPrice||''}}</text>
										<text class="tui-factory-price">￥{{item.marketPrice||''}}</text>
									</view>
									<view class="tui-pro-pay">{{item.sales||0}}人付款</view>
								</view>
							</view>
						</view>
					</block>
				</view>
				<view class="tui-product-container">
					<block v-for="(item, index) in newGoods" :key="index" v-if="(index+1)%2==0">
						<!--商品列表-->
						<view class="tui-pro-item" hover-class="hover" :hover-start-time="150" @tap="goodsDetail(item.id)">
							<image :src="item.listPicUrl" class="tui-pro-img" mode="widthFix" />
							<view class="tui-pro-content">
								<view class="tui-pro-tit">{{item.goodsName||''}}</view>
								<view>
									<view class="tui-pro-price">
										<text class="tui-sale-price">￥{{item.retailPrice||''}}</text>
										<text class="tui-factory-price">￥{{item.marketPrice||''}}</text>
									</view>
									<view class="tui-pro-pay">{{item.sales||0}}人付款</view>
								</view>
							</view>
						</view>
					</block>
				</view>
			</view>
		</view>
		<view class="tui-tabbar">
			<tui-footer backgroundColor="#fafafa" :fixed="false" copyright="Copyright © 2020 安徽微同科技有限公司 All Rights Reserved."
			 bgcolor="#fafafa"></tui-footer>
		</view>

		<tui-bottom-popup :show="faceShow" @close="closePayFace">
			<tui-list-cell :hover="false">
				<view class="tui-pay-item__title">
					<view>当面付</view>
					<input type="digit" class="tui-pay-amuont" v-model="money" placeholder="请询问商家后输入" placeholder-class="tui-phcolor"></input>
				</view>
			</tui-list-cell>
			<radio-group @change="radioChange">
				<tui-list-cell unlined v-for="(item, index) in shopsList" :key="index">
					<label class="tui-pay-item">
						<image :src="item.imgUrl" class="tui-pay-logo"></image>
						<text>{{item.name}}</text>
						<view class="tui-radio">
							<radio color="#EB0909" name="shopsId" :value="item.id"></radio>
						</view>
					</label>
				</tui-list-cell>
			</radio-group>
			<view class="tui-btn-pay">
				<tui-button height="88rpx" type="danger" shape="circle" shadow @click="pay">去付款</tui-button>
			</view>
		</tui-bottom-popup>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	const app = getApp()
	export default {
		data() {
			return {
				height: 64, //header高度
				top: 0, //标题图标距离顶部距离
				scrollH: 0, //滚动总高度
				opcity: 0,
				iconOpcity: 0.5,
				unPayNum: 0,
				unTakeNum: 0,
				unEvalNum: 0,
        shNum: 0,
				unSendNum: 0,
				couponCount: 0,
				newGoods: [],
				curUser: {
					balance: 0,
          integral: 0,
					isDistributor: 0,
          headImgUrl: ''
				},
				userInfo: {},
				faceShow: false,
				money: '',
				shopsId: '',
				shopsList: [],
				distributionStatus: 2
			}
		},
		onShareAppMessage: function() {
			return {
				title: '个人中心',
				desc: '个人中心',
				path: '/pages/ucenter/index/index'
			}
		},

		onLoad: function(options) {
			this.width = app.globalData.customBar.width
			this.height = app.globalData.customBar.height
			this.top = app.globalData.customBar.top
			this.scrollH = app.globalData.customBar.scrollH
		},
		onPageScroll(e) {
			let scroll = e.scrollTop <= 0 ? 0 : e.scrollTop;
			let opcity = scroll / this.scrollH;
			if (this.opcity >= 1 && opcity >= 1) {
				return;
			}
			this.opcity = opcity
			this.iconOpcity = 0.5 * (1 - opcity < 0 ? 0 : 1 - opcity)
		},
		onShow: function() {
			this.initial();
			uni.setStorageSync("navUrl", "/pages/ucenter/index/index");
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
		methods: {
			closePayFace: function() {
				this.faceShow = false
				this.money = ''
			},
			payFace: function() {
				this.faceShow = true
			},
			getShopsList: function() {
				let that = this;
				util.request('shops/shopsList').then(function(res) {
					let shopsList = res.data;
					shopsList.forEach(function(item) {
						item.distant = util.getDistance(that.latitude, that.longitude, item.latitude, item.longitude)
					})
					that.shopsList = shopsList
				});
			},
			radioChange: function(evt) {
				for (let i = 0; i < this.shopsList.length; i++) {
					if (this.shopsList[i].id === evt.target.value) {
						this.shopsId = evt.target.value;
						break;
					}
				}
			},
			pay: function() {
				let that = this;
				if (!uni.getStorageSync('token')) {
					util.toast('您还没登录哦');
					return;
				}
				if (!util.isMoney(that.money)) {
					util.toast('请输入正确的金额')
					return;
				}
				if (!that.shopsId) {
					util.toast('请选择门店')
					return;
				}
				util.faceToface(that.money, that.shopsId).then(res => {
					util.toast('付款成功')
				}).catch(res => {
					util.toast('付款失败')
				});
				this.faceShow = false
			},
			initial: function() {
				let that = this;
				let userInfo = uni.getStorageSync('userInfo');
				let token = uni.getStorageSync('token');

				// 页面显示
				if (userInfo && token) {
					app.globalData.userInfo = userInfo;
					app.globalData.token = token;
				}

				that.userInfo = app.globalData.userInfo;

				that.getShopsList();
				util.request('index/getDistributionStatus').then(res => {
					if (res.code === 0) {
						that.distributionStatus = res.distributionStatus
					}
				});

				util.request('user/userInfo').then(function(res) {
					if (res.code === 0) {
            that.curUser = res.data;
						util.request('index/userCount', {}).then(function(res) {
							if (res.code === 0) {
								that.unPayNum = res.countMap.unPayNum || 0
								that.unSendNum = res.countMap.unSendNum || 0
								that.unTakeNum = res.countMap.unTakeNum || 0
								that.unEvalNum = res.countMap.unEvalNum || 0
                that.shNum = res.countMap.shNum || 0
							}
							that.getNewGoodsList()
						});
						util.request('coupon/userCount', {}).then(function(res) {
							if (res.code === 0) {
								that.couponCount = res.data || 0
							}
						});
					}
				});
			},
			goLogin() {
				if (uni.getStorageSync('token')) {
					uni.navigateTo({
						url: '/pages/ucenter/set/set'
					})
				} else {
					uni.navigateTo({
						url: '/pages/auth/btnAuth/btnAuth',
					})
				}
			},
			goodsDetail: function(goodsId) {
				uni.navigateTo({
					url: '/pages/goods/goods?id=' + goodsId,
				})
			},
			orderList(e) {
				if (!uni.getStorageSync('token')) {
					util.toast('您还没登录哦');
					return;
				}
				uni.navigateTo({
					url: '/pages/ucenter/order/order?currentTab=' + Number(e.currentTarget.dataset.type)
				})
			},
			setting() {
				if (!uni.getStorageSync('token')) {
					util.toast('您还没登录哦');
					return;
				}
				uni.navigateTo({
					url: '/pages/ucenter/set/set'
				})
			},
			goAsset(e) {
				let that = this;
				let type = Number(e.currentTarget.dataset.type)
				if (type === 10) {
					uni.navigateTo({
						url: '/pages/ucenter/company/company'
					})
				} else {
					if (!uni.getStorageSync('token')) {
						util.toast('您还没登录哦');
						return;
					}
					let url;
					switch (type) {
						case 1:
							url = '/pages/ucenter/yue/yue?now=' + that.curUser.balance;
							break;
						case 2:
              url = '/pages/ucenter/integrals/integrals';
							break;
						case 3:
							url = '/pages/ucenter/coupon/coupon';
							break;
						case 4:
							url = '/pages/ucenter/skill/skill';
							break;
						case 5:
							url = '/pages/ucenter/collect/collect';
							break;
						case 6:
							url = '/pages/ucenter/footprint/footprint';
							break;
						case 7:
							url = '/pages/shopping/address/address?prePageType=2';
							break;
						case 8:
							url = '/pages/feedback/feedback';
							break;
						case 9:
							url = '/pages/ucenter/kefu/kefu';
							break;
						case 11:
							url = that.curUser.isDistributor ? '/pages/dcenter/index/index' : '/pages/dcenter/apply/apply';
							break;
						case 12:
							url = '/pages/ucenter/faceToFace/faceToFace';
							break;
            case 13:
              url = '/pages/groupOrderList/groupOrderList';
              break;
					}
					if (url) {
						uni.navigateTo({
							url
						});
					}
				}
			},
			getNewGoodsList() {
				let that = this;

				util.request('goods/list', {
					type: 'IS_NEW'
				}).then(function(res) {
					if (res.code === 0) {
						that.newGoods = res.data.records;
					}
				});
			},
			downContract: function() {
				const downloadTask = uni.downloadFile({
					url: 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/contract-template.docx',
					success(res) {
						uni.hideLoading();

						const filePath = res.tempFilePath;

						// 只要服务器有响应数据，就会把响应内容写入文件并进入 success 回调，业务需要自行判断是否下载到了想要的内容
						if (res.statusCode === 200) {
							uni.showModal({
								title: '提示',
								content: "是否预览文档？",
								success: function(res) {
									if (res.confirm) {
										uni.openDocument({
											filePath,
											success(res) {}
										})
									}
								}
							})
						}
					}
				})
				downloadTask.onProgressUpdate((res) => {
					uni.showLoading({
						title: '下载进度：' + res.progress + '%'
					})
				})
			},
			exitLogin: function() {
				uni.showModal({
					title: '',
          // #ifndef MP-ALIPAY
          // 支付宝小程序不支持
          confirmColor: '#b4282d',
          // #endif
					content: '退出登录？',
					success: function(res) {
						if (res.confirm) {
							uni.removeStorageSync('token');
							uni.removeStorageSync('userInfo');
							uni.switchTab({
								url: '/pages/index/index'
							});
						}
					}
				})
			}
		}
	}
</script>

<style>
	page {
		background-color: #fafafa;
	}

	.tui-header-box {
		width: 100%;
		position: fixed;
		left: 0;
		top: 0;
		z-index: 9998;
	}

	.tui-header {
		width: 100%;
		font-size: 18px;
		line-height: 18px;
		font-weight: 500;
		height: 32px;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	/* #ifndef MP */
	.tui-header-icon {
		position: fixed;
		top: 0;
		right: 15px;
		display: flex;
		align-items: center;
		justify-content: space-between;
		height: 32px;
		transform: translateZ(0);
		z-index: 99999;
	}

	/* #endif */
	/* #ifdef MP */
	.tui-set-box {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	/* #endif */
	.tui-icon-box {
		position: relative;
	}

	.tui-icon-setup {
		margin-left: 16rpx;
	}

	.tui-badge {
		position: absolute;
		font-size: 24rpx;
		height: 32rpx;
		min-width: 20rpx;
		padding: 0 6rpx;
		border-radius: 40rpx;
		right: 10rpx;
		top: -5rpx;
		transform: scale(0.8) translateX(60%);
		transform-origin: center center;
		display: flex;
		align-items: center;
		justify-content: center;
		z-index: 10;
	}

	.tui-badge-red {
		background: #F74D54;
		color: #fff;
	}

	.tui-badge-white {
		background: #fff;
		color: #F74D54;
	}

	.tui-badge-dot {
		position: absolute;
		height: 12rpx;
		width: 12rpx;
		border-radius: 50%;
		right: -12rpx;
		top: 0;
		background: #F74D54;
	}

	.tui-mybg-box {
		width: 100%;
		height: 464rpx;
		position: relative;
	}

	.tui-my-bg {
		width: 100%;
		height: 464rpx;
		display: block;
	}

	.tui-header-center {
		position: absolute;
		width: 100%;
		height: 128rpx;
		left: 0;
		top: 120rpx;
		padding: 0 30rpx;
		box-sizing: border-box;
		display: flex;
		align-items: center;
	}

	.tui-avatar {
		flex-shrink: 0;
		width: 128rpx;
		height: 128rpx;
		display: block;
	}

	.tui-info {
		width: 60%;
		padding-left: 30rpx;

	}

	.tui-nickname {
		font-size: 30rpx;
		font-weight: 500;
		color: #fff;
		display: flex;
		align-items: center;
	}

	.nickname {
		max-width: 180rpx;
	}

	.tui-img-vip {
		width: 56rpx;
		height: 24rpx;
		margin-left: 18rpx;
	}

	.tui-explain {
		width: 80%;
		font-size: 24rpx;
		font-weight: 400;
		color: #fff;
		opacity: 0.75;
		padding-top: 8rpx;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.tui-btn-edit {
		flex-shrink: 0;
		padding-right: 22rpx;
	}

	.tui-header-btm {
		width: 100%;
		padding: 0 30rpx;
		box-sizing: border-box;
		position: absolute;
		left: 0;
		top: 280rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
		color: #fff;
	}

	.tui-btm-item {
		flex: 1;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
	}

	.tui-btm-num {
		font-size: 32rpx;
		font-weight: 600;
		position: relative;
	}

	.tui-btm-text {
		font-size: 24rpx;
		opacity: 0.85;
		padding-top: 4rpx;
	}

	.tui-content-box {
		width: 100%;
		padding: 0 30rpx;
		box-sizing: border-box;
		position: relative;
		top: -72rpx;
		z-index: 10;
	}

	.tui-box {
		width: 100%;
		background: #fff;
		box-shadow: 0 3rpx 20rpx rgba(183, 183, 183, 0.3);
		border-radius: 20rpx;
		overflow: hidden;
	}

	.tui-order-box {
		height: 208rpx;
	}

	.tui-cell-header {
		width: 100%;
		height: 74rpx;
		padding: 0 26rpx;
		box-sizing: border-box;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.tui-cell-title {
		font-size: 30rpx;
		line-height: 30rpx;
		font-weight: 600;
		color: #333;
	}

	.tui-cell-sub {
		font-size: 26rpx;
		font-weight: 400;
		color: #999;
		padding-right: 28rpx;
	}

	.tui-order-list {
		width: 100%;
		height: 134rpx;
		padding: 0 30rpx;
		box-sizing: border-box;
		display: flex;
		align-items: center;
	}

	.tui-order-item {
		flex: 1;
		display: flex;
		flex-direction: column;
		align-items: center;
	}

	.tui-order-text,
	.tui-tool-text {
		font-size: 26rpx;
		font-weight: 400;
		color: #666;
		padding-top: 4rpx;
	}

	.tui-tool-text {
		font-size: 24rpx;
	}

	.tui-order-icon {
		width: 56rpx;
		height: 56rpx;
		display: block;
	}

	.tui-assets-box {
		height: 178rpx;
		margin-top: 20rpx;
	}

	.tui-assets-list {
		height: 84rpx;
	}

	.tui-assets-num {
		font-size: 32rpx;
		font-weight: 500;
		color: #333;
		position: relative;
	}

	.tui-assets-text {
		font-size: 24rpx;
		font-weight: 400;
		color: #666;
		padding-top: 6rpx;
	}

	.tui-tool-box {
		margin-top: 20rpx;
	}

	.tui-flex-wrap {
		flex-wrap: wrap;
		height: auto;
		padding-bottom: 30rpx;
	}

	.tui-tool-item {
		width: 25%;
		display: flex;
		align-items: center;
		justify-content: center;
		flex-direction: column;
		padding-top: 30rpx;
	}

	.tui-tool-icon {
		width: 64rpx;
		height: 64rpx;
		display: block;
	}

	.tui-badge-icon {
		width: 66rpx;
		height: 30rpx;
		position: absolute;
		right: 0;
		transform: translateX(88%);
		top: -15rpx;
	}

	/*为你推荐*/
	.tui-product-list {
		display: flex;
		justify-content: space-between;
		flex-direction: row;
		flex-wrap: wrap;
		box-sizing: border-box;
		margin-bottom: 100rpx;
	}

	.tui-product-container {
		flex: 1;
		margin-right: 2%;
	}

	.tui-product-container:last-child {
		margin-right: 0;
	}

	.tui-pro-item {
		width: 100%;
		margin-bottom: 4%;
		background: #fff;
		box-sizing: border-box;
    box-shadow: 0 3rpx 20rpx rgba(183, 183, 183, 0.3);
    border-radius: 20rpx;
		overflow: hidden;
	}

	.tui-pro-img {
		width: 100%;
		display: block;
	}

	.tui-pro-content {
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		box-sizing: border-box;
		padding: 20rpx;
	}

	.tui-pro-tit {
		color: #2e2e2e;
		font-size: 26rpx;
		word-break: break-all;
		overflow: hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
	}

	.tui-pro-price {
		padding-top: 18rpx;
	}

	.tui-sale-price {
		font-size: 34rpx;
		font-weight: 500;
		color: #e41f19;
	}

	.tui-factory-price {
		font-size: 24rpx;
		color: #a0a0a0;
		text-decoration: line-through;
		padding-left: 12rpx;
	}

	.tui-pro-pay {
		padding-top: 10rpx;
		font-size: 24rpx;
		color: #656565;
	}

	.tui-invalid-ptop {
		padding-top: 40rpx;
	}

	.tui-tabbar {
		position: fixed;
		left: 0;
		bottom: 0;
		/* #ifdef H5 */
		bottom: 50px;
		/* #endif */
		z-index: 99998;
		width: 100%;
	}

	.tui-tabbar::before {
		content: '';
		width: 100%;
		border-top: 1rpx solid #d9d9d9;
		position: absolute;
		top: 0;
		left: 0;
		-webkit-transform: scaleY(0.5);
		transform: scaleY(0.5);
	}

	.tui-pay-item__title {
		width: 100%;
		height: 90rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 0 20rpx;
		box-sizing: border-box;
		font-size: 28rpx;
	}

	.tui-pay-amuont {
		color: #eb0909;
		font-weight: 500;
		font-size: 34rpx;
	}

	.tui-pay-item {
		width: 100%;
		height: 80rpx;
		display: flex;
		align-items: center;
		padding: 0 20rpx;
		box-sizing: border-box;
		font-size: 28rpx;
	}

	.tui-pay-logo {
		width: 48rpx;
		height: 48rpx;
		margin-right: 15rpx;
	}

	.tui-radio {
		margin-left: auto;
		transform: scale(0.8);
		transform-origin: 100% center;
	}

	.tui-btn-pay {
		width: 100%;
		padding: 68rpx 35rpx 150rpx 35rpx;
		/* #ifdef H5 */
		padding: 68rpx 35rpx 200rpx 35rpx;
		/* #endif */
		box-sizing: border-box;
	}
</style>

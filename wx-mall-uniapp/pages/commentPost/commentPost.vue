<template>
	<view class="container">
		<view class="list-group" style="margin-top: 0px;">
			<view class="list-cell">
				<view class="list-cell-bd">
					<view class="list-label" style="padding-left: 20rpx;">
            亲爱的{{orderInfo.consignee||''}}
					</view>
				</view>
				<view class="list-cell-ft" style="font-size: .7em;">
          给个好评，亲 ^_^
				</view>
			</view>
		</view>

		<view class="service-box">
			<view class="service-item">
				<text class="label">服务态度</text>
				<view class="star-box">
					<tui-rate :current="evalLevel" @change="handleEvalScore"></tui-rate>
				</view>
				<text class="desc">{{handleDesc[evalLevel -1]}}</text>
			</view>
			<view class="service-item">
				<text class="label">配送速度</text>
				<view class="star-box">
					<tui-rate :current="deliveryLevel" @change="handleDeliveryScore"></tui-rate>
				</view>
				<text class="desc">{{handleDesc[deliveryLevel -1]}}</text>
			</view>
		</view>

		<view class="goods-list" v-for="(item, num) in goodsList" :key="num">
			<view class="list-group">
				<view class="list-cell">
					<view class="list-cell-hd">
						<image style="width: 100rpx;height:100rpx;" :src="item.listPicUrl"></image>
					</view>
					<view class="list-cell-bd" style="padding-left: 20rpx;">
						<view class="list-label">
							{{item.goodsName}}
						</view>
						<view class="list-label-desc">
							{{item.goodsSpecifitionNameValue}}
						</view>
					</view>
				</view>
				<view class="service-item" style="padding-left:20px">
					<text class="label">商品质量</text>
					<view class="star-box">
						<tui-rate :current="goodsList[num].goodsLevel" :params="num" @change="handleScore"></tui-rate>
					</view>
					<text class="desc">{{handleDesc[goodsList[num].goodsLevel -1]}}</text>
				</view>

				<view class="input-box">
					<textarea class="content" @input="bindInpuntValue" auto-height :data-goods-index="num" maxlength="140" placeholder="留言经过筛选后，对所有人可见" />
					<text class="count">{{goodsList[num].comment.length}}/140</text>
				</view>
			  <view class="pic-box">
				<view class="pic-item" v-for="(item, index) in goodsList[num].pics" :key="index">
				  <image :src="item" @tap="previewPic" :data-urls="goodsList[num].pics"></image>
				  <text class="pic-delete" @tap="handleDelete" :data-src="item" :data-pics="goodsList[num].pics" :data-goods-index="num">x</text>
				</view>
				<view class="pic-item pic-handle" v-if="goodsList[num].pics.length < 3" @tap="chooseImageTap" :data-pics="goodsList[num].pics" :data-goods-index="num">
				  <image src="/static/images/mall/photo_icon.png"></image>
				  <text class="desc">添加图片</text>
				</view>
			  </view>
			</view>
		  </view>
		  <view class="btn-box">
			<button type="primary" @click="onPost">发 布</button>
		  </view>
		</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				type: 0,
				evalLevel: 5, //服务态度
				deliveryLevel: 5, //配送速度
				goodsList: [{
					goodsLevel: 5,
					comment: '',
					pics: []
				}],
				orderId: 0,
				orderInfo: {}, // 订单详情
				orderGoods: {}, // 订单商品
				handleDesc: ['很差', '一般', '满意', '很满意', '非常满意']
			}
		},
		onLoad: function(options) {
			var that = this;
			that.type= options.type
			that.orderId= options.orderId
			that.getOrderDetail();
		},
		methods: {
			handleEvalScore(e){
				this.evalLevel = e.index
			},
			handleDeliveryScore(e){
				this.deliveryLevel = e.index
			},
			handleScore(e) {
				this.goodsList[e.custom].goodsLevel = e.index
			},
			previewPic(e) {
				let urls = e.currentTarget.dataset.urls;
				uni.previewImage({
					urls
				})
			},
			handleDelete(e) {
				let that = this;
				let src = e.currentTarget.dataset.src;
				let goodsIndex = e.currentTarget.dataset.goodsIndex;
				let pics = e.currentTarget.dataset.pics || [];
				pics = pics.filter(item => item != src);
				//
				let goodsList = that.goodsList;
				goodsList[goodsIndex].pics = pics;
				this.goodsList= goodsList
			},
			bindInpuntValue(event) {
				let that = this;
				let goodsIndex = event.target.dataset.goodsIndex;
				let value = event.detail.value;
				this.goodsList[goodsIndex].comment = value
			},
			chooseImageTap: function(e) {
				let that = this;
				let goodsIndex = e.currentTarget.dataset.goodsIndex;
				uni.showActionSheet({
					itemList: ['从相册中选择', '拍照'],
					itemColor: "#e41f19",
					success: function(res) {
						if (!res.cancel) {
							if (res.tapIndex == 0) {
								that.chooseWxImage('album', goodsIndex)
							} else if (res.tapIndex == 1) {
								that.chooseWxImage('camera', goodsIndex)
							}
						}
					}
				})
			},
			chooseWxImage: function(type, goodsIndex) {
				let _this = this;
				uni.chooseImage({
					sizeType: ['original', 'compressed'],
					sourceType: [type],
					success: function(res) {
						var tempFilePaths = res.tempFilePaths
						for (const key in tempFilePaths) {
							util.uploadFile('upload/upload', tempFilePaths[key]).then(function(res){
								_this.goodsList[goodsIndex].pics.push(res.url);
							})
						}
					}
				})
			},
			onPost() {
				let that = this;
				let flag = this.goodsList.every(function(element, index, array) {
					if (element.comment) {
						return true;
					} else {
						return false;
					}
				});
				if(!flag){
					util.toast('请填写评价内容')
					return;
				}
				util.request('comment/post', {
					orderId: that.orderId,
					goodsList: that.goodsList,
					evalLevel: that.evalLevel,
					deliveryLevel: that.deliveryLevel,
					type: that.type
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						util.toast('评论成功');
						setTimeout(function() {
							uni.navigateBack({
								delta: 2,
								fail: (res) => {
									uni.switchTab({
										url: '/pages/index/index',
									})
								}
							});
						}, 2000);
					}
				});
			},
			getOrderDetail() {
				let that = this;
				util.request('order/detail', {
					orderId: that.orderId
				}).then(function(res) {
					if (res.code === 0) {
						that.orderInfo= res.orderInfo
						that.orderGoods= res.orderGoods
						var goodsList = new Array();
						for (var i = 0; i < res.orderGoods.length; i++) {
							let goodVo = {};
							goodVo.goodsId = res.orderGoods[i].goodsId;
							goodVo.goodsName = res.orderGoods[i].goodsName;
							goodVo.listPicUrl = res.orderGoods[i].listPicUrl;
							goodVo.skuId = res.orderGoods[i].skuId;
							goodVo.goodsSpecifitionNameValue = null != res.orderGoods[i].goodsSpecifitionNameValue ? res.orderGoods[i].goodsSpecifitionNameValue :
								"";
							goodVo.goodsLevel = 5;
							goodVo.pics = [];
							goodVo.comment = '';
							goodsList.push(goodVo);
						}
						that.goodsList= goodsList
					}
				});
			}
		}
	}
</script>

<style>
	page,
	.container {
		height: 100%;
		background: #f4f4f4;
	}

	.list-group {
		margin-top: 1.17647059em;
		background-color: #fff;
		line-height: 1.41176471;
		font-size: 28rpx;
		overflow: hidden;
		position: relative;
	}

	.list-group::before {
		content: " ";
		position: absolute;
		left: 0;
		top: 0;
		right: 0;
		height: 1px;
		border-top: 1px solid #d9d9d9;
		color: #d9d9d9;
		transform-origin: 0 0;
		transform: scaleY(0.5);
	}

	.list-group::after {
		content: " ";
		position: absolute;
		left: 0;
		bottom: 0;
		right: 0;
		height: 1px;
		border-bottom: 1px solid #d9d9d9;
		color: #d9d9d9;
		transform-origin: 0 100%;
		transform: scaleY(0.5);
	}

	.list-cell {
		padding: 10px 15px;
		position: relative;
		display: flex;
		align-items: center;
	}

	.list-cell:first-of-type::before {
		display: none;
	}

	.list-cell::before {
		content: " ";
		position: absolute;
		top: 0;
		right: 0;
		height: 1px;
		border-top: 1px solid #d9d9d9;
		color: #d9d9d9;
		transform-origin: 0 0;
		transform: scaleY(0.5);
		left: 15px;
	}

	.list-cell-hd {
		display: flex;
		align-items: center;
	}

	.list-cell-bd {
		flex: 1;
	}

	.list-cell-bd .list-label {
		font-size: 1em;
	}

	.list-cell-bd .list-label-desc {
		font-size: 0.9em;
		color: #9b9b9b;
		padding-top: 5px;
	}

	.list-cell-ft {
		padding-right: 13px;
		position: relative;
		text-align: right;
		color: #999;
	}

	.list-cell-ft.router::after {
		content: " ";
		display: inline-block;
		height: 6px;
		width: 6px;
		border-width: 2px 2px 0 0;
		border-color: #c8c8cd;
		border-style: solid;
		transform: matrix(0.71, 0.71, -0.71, 0.71, 0, 0);
		top: -2px;
		position: absolute;
		top: 50%;
		margin-top: -4px;
		right: 2px;
	}

	.service-box {
		background-color: #fff;
		margin-top: 10px;
		padding: 0 20px;
	}

	.service-item {
		height: 100rpx;
		display: flex;
		align-items: center;
	}

	.service-item .label {
		color: #999;
	}

	.service-item text:not(.label) {
		padding-left: 10px;
	}

	.star-box .star {
		font-size: 1.7em;
		padding-left: 5px;
		color: #ddd;
	}

	.star-box .star.checked {
		color: #feb54c;
	}

	.goods-list {
		background-color: #fff;
	}

	.goods-list .input-box {
		border: 1px solid #ccc;
		margin: 0 20px;
		padding: 10px;
		padding-bottom: 25px;
	}

	.goods-list .input-box .content {
		width: 100%;
	}

	.goods-list .input-box .count {
		float: right;
	}

	.pic-box {
		margin-top: 10px;
		padding: 0 20px;
		padding-bottom: 20px;
		display: flex;
		flex-wrap: nowrap;
	}

	.pic-item {
		position: relative;
		width: 200rpx;
		height: 200rpx;
		margin-right: 10px;
		display: inline-block;
	}

	.pic-item image {
		width: 100%;
		height: 100%;
	}

	.pic-item .pic-delete {
		position: absolute;
		width: 30rpx;
		height: 30rpx;
		text-align: center;
		color: #fff;
		line-height: 30rpx;
		top: -15rpx;
		right: -15rpx;
		border-radius: 50%;
		background-color: red;
	}

	.pic-handle {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		flex-direction: column;
		border: 1px solid #ccc;
		border-radius: 3px;
	}

	.pic-item.pic-handle image {
		width: 100rpx;
		height: 100rpx;
	}

	.pic-handle .desc {
		padding-top: 10px;
		font-size: 0.9em;
		color: #9b9b9b;
	}

	.coupon {
		margin-top: 24rpx;
		margin-left: 40rpx;
		display: flex;
		margin-right: 40rpx;
		flex-direction: row;
		align-items: center;
	}

	.coupon .left {
		flex: 1;
	}

	.btn-box {
		margin: 20px 0;
		padding: 10px 20px;
	}

	.name {
		font-size: 34rpx;
		color: #fff;
		margin-bottom: 14rpx;
	}

	.time {
		font-size: 24rpx;
		color: rgba(255, 255, 255, 0.8);
		line-height: 30rpx;
	}

	.coupon .right {
		width: 162rpx;
	}

	.condition {
		position: absolute;
		width: 100%;
		bottom: 0;
		left: 0;
		height: 78rpx;
		background: rgba(0, 0, 0, 0.08);
		padding: 24rpx 40rpx;
		display: flex;
		flex-direction: row;
	}

	.condition .txt {
		display: block;
		height: 30rpx;
		flex: 1;
		overflow: hidden;
		font-size: 24rpx;
		line-height: 30rpx;
		color: #fff;
	}

	.condition .icon {
		margin-left: 30rpx;
		width: 24rpx;
		height: 24rpx;
	}

	.drawer_box {
		width: 650rpx;
		overflow: hidden;
		position: fixed;
		top: 50%;
		left: 0;
		z-index: 1001;
		background: #f4f4f4;
		margin: -150px 50rpx 0 50rpx;
		border-radius: 3px;
	}

	.drawer_title {
		padding: 15px;
		font: 20px "microsoft yahei";
		text-align: center;
		background: #e41f19;
	}

	.drawer_content {
		height: 410px;
		overflow-y: scroll;
		/*超出父盒子高度可滚动*/
	}

	.btn_ok {
		padding: 10px;
		font: 20px "microsoft yahei";
		text-align: center;
		border-top: 1px solid #e8e8ea;
		color: #e41f19;
	}

	.coupon-box {
		background-color: #fff;
		display: flex;
		border-radius: 5px;
		flex-direction: row;
		position: relative;
	}

	.coupon-box .coupon-used {
		position: absolute;
		top: 50%;
		right: 10px;
		margin-top: -7.5vmin;
		height: 15vmin;
		width: 15vmin;
		background: url(https://www.meiping123.com/statics/img/icon_used.png) no-repeat center;
		background-size: contain;
	}

	.coupon-box-g {
		background: linear-gradient(to right, #f0f0f0, #fff);
	}

	.coupon-bg {
		width: 35%;
		background-position: left;
		background-size: cover;
		color: #fff;
		font-size: 2.4rem;
		display: flex;
		justify-content: center;
		flex-direction: column;
		align-items: center;
	}

	.coupon-bg>view {
		font-size: inherit;
		color: #fff;
	}

	.coupon-bg .coupon-currency {
		font-size: 1rem;
		padding-right: 5px;
		color: #fff;
	}

	.coupon-bg .coupon-type {
		font-size: 0.8rem;
		color: #fff;
	}

	.coupon-bg1 {
		background-image: url(https://www.meiping123.com/statics/img/bg_1.png);
	}

	.coupon-bg2 {
		background-image: url(https://www.meiping123.com/statics/img/bg_2.png);
	}

	.coupon-info {
		width: 50%;
		margin-left: 40px;
	}

	.coupon-info .coupon-title {
		font-size: 1.1rem;
		padding: 8px 0 4px 0;
	}

	.coupon-info .coupon-desc {
		font-size: 0.9rem;
		color: #9b9b9b;
		list-style: outside;
		padding: 4px 0 8px 0;
	}
</style>

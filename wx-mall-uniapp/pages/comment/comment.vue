<template>
	<view class="comments">
		<view class="h">
			<view :class="'item ' + (showType == 0 ? 'active' : '')" @tap="switchTab">
				<view class="txt">全部({{goodsCount}})</view>
			</view>
			<view :class="'item ' + ( showType == 0 ? '' : 'active')" @tap="switchTab">
				<view class="txt">有图({{picCount}})</view>
			</view>
		</view>
		<view class="b">
			<view class="item" v-for="(item, index) in comments" :key="index">
				<view class="info">
					<view class="user">
						<image :src="item.userInfo.headImgUrl"></image>
						<text>{{item.userInfo.nickname}}</text>
					</view>
					<view class="time">{{item.addTime}}</view>
					<view class="status" v-if="item.status ===0">待审核</view>
				</view>
				<view class="comment">{{item.content}}</view>
				<view class="imgs" v-if="item.commentPictureEntityList.length > 0">
					<image class="img" :data-urls="item.commentPictureEntityList" v-for="(pitem, index) in item.commentPictureEntityList"
					 @tap="previewPic" :data-index="index" :key="pitem.id" :src="pitem.picUrl"></image>
				</view>
				<view class="service-box">
					<view class="service-item">
						<text class="label">服务态度</text>
						<view class="star-box">
							<tui-rate :current="item.evalLevel"></tui-rate>
						</view>
					</view>
					<view class="service-item">
						<text class="label">商品质量</text>
						<view class="star-box">
							<tui-rate :current="item.goodsLevel"></tui-rate>
						</view>
					</view>
				</view>
			</view>

		</view>
	</view>

</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				comments: [],
				picCommentList: [],
				type: 0,
				from: 0,
				goodsId: '',
				orderId: '',
				showType: 0,
				goodsCount: 0,
				picCount: 0,
				allPage: 1,
				picPage: 1,
				limit: 20
			}
		},
		onLoad: function(options) {
			// 页面初始化 options为页面跳转所带来的参数
			if (options.type) {
				this.type = options.type
			}
			if (options.from) {
				this.from = options.from
			}
			if (options.goodsId) {
				this.goodsId = options.goodsId
			}
			if (options.orderId) {
				this.orderId = options.orderId
			}
			this.getCommentCount();
			this.getCommentList();
		},
		onReachBottom: function() {
			if (this.showType == 0) {
				if (this.goodsCount / this.limit < this.allPage) {
					return false;
				}

				this.allPage = this.allPage + 1;
			} else {
				if (this.picCount / this.limit < this.picPage) {
					return false;
				}

				this.picPage = this.picPage + 1;
			}
			this.getCommentList();
		},
		methods: {
			switchTab: function() {
				this.showType = this.showType == 1 ? 0 : 1

				this.getCommentList();
			},
			getCommentCount: function() {
				let that = this;
				util.request('comment/count', {
					goodsId: that.goodsId,
					type: that.type,
					from: that.from,
					orderId: that.orderId
				}).then(function(res) {
					if (res.code === 0) {
						that.goodsCount = res.goodsCount
						that.picCount = res.picCount
					}
				});
			},
			getCommentList: function() {
				let that = this;
				util.request('comment/list', {
					goodsId: that.goodsId,
					type: that.type,
					from: that.from,
					orderId: that.orderId,
					limit: that.limit,
					current: (that.showType == 0 ? that.allPage : that.picPage),
					showType: that.showType
				}).then(function(res) {
					if (res.code === 0) {
						if (that.showType == 0) {
							that.allPage = res.data.pages
							that.comments = res.data.records
						} else {
							that.picPage = res.data.pages
							that.comments = res.data.records
						}
					}
				});
			},
			previewPic(e) {
				let urls = e.currentTarget.dataset.urls;
				let index = e.currentTarget.dataset.index;

				let picUrls = urls.map(function(element, index, array) {
					return element.picUrl;
				});
				uni.previewImage({
					urls: picUrls,
					current: index
				})
			}
		}
	}
</script>

<style>
	.comments {
		width: 100%;
		height: auto;
		padding-left: 30rpx;
		background: #fff;
		margin: 20rpx 0;
	}

	.comments .h {
		position: fixed;
		left: 0;
		top: 0;
		z-index: 1000;
		width: 100%;
		display: flex;
		background: #fff;
		height: 84rpx;
		border-bottom: 1px solid rgba(0, 0, 0, 0.15);
	}

	.comments .h .item {
		display: inline-block;
		height: 82rpx;
		width: 50%;
		padding: 0 15rpx;
		text-align: center;
	}

	.comments .h .item .txt {
		display: inline-block;
		height: 82rpx;
		padding: 0 20rpx;
		line-height: 82rpx;
		color: #333;
		font-size: 30rpx;
		width: 170rpx;
	}

	.comments .h .item.active .txt {
		color: #ab2b2b;
		border-bottom: 4rpx solid #ab2b2b;
	}

	.comments .b {
		margin-top: 85rpx;
		height: auto;
		width: 720rpx;
	}

	.comments .b.no-h {
		margin-top: 0;
	}

	.comments .item {
		height: auto;
		width: 720rpx;
		overflow: hidden;
		border-bottom: 1px solid #d9d9d9;
		padding-bottom: 25rpx;
	}

	.comments .info {
    height: 80rpx;
		width: 100%;
    padding: 25rpx 0;
	}

	.comments .user {
		float: left;
		width: auto;
		height: 67rpx;
		line-height: 67rpx;
		font-size: 0;
	}

	.comments .user image {
		float: left;
		width: 67rpx;
		height: 67rpx;
		margin-right: 17rpx;
		border-radius: 50%;
	}

	.comments .user text {
		display: inline-block;
		width: auto;
		height: 66rpx;
		overflow: hidden;
		font-size: 26rpx;
		line-height: 66rpx;
	}

	.comments .time {
		display: block;
		float: right;
		width: auto;
		height: 67rpx;
		line-height: 67rpx;
		color: #7f7f7f;
		font-size: 25rpx;
		margin-right: 30rpx;
	}

	.comments .status {
		display: block;
		float: right;
		width: auto;
		height: 67rpx;
		line-height: 67rpx;
		color: #e41f19;
		font-size: 25rpx;
		margin-right: 30rpx;
	}


	.comments .comment {
		width: 720rpx;
		padding-right: 30rpx;
		line-height: 45.8rpx;
		font-size: 26rpx;
		margin-bottom: 16rpx;
	}

	.comments .imgs {
		width: 720rpx;
		height: 150rpx;
		margin-bottom: 25rpx;
	}

	.comments .imgs .img {
		height: 150rpx;
		width: 150rpx;
		margin-right: 28rpx;
	}

	.comments .spec {
		width: 720rpx;
		height: 25rpx;
		font-size: 24rpx;
		color: #999;
	}

	.comments .spec .item {
		color: #7f7f7f;
		font-size: 25rpx;
	}

	.service-box {
    font-size: 24rpx;
		background-color: #fff;
		margin-top: 0px;
		padding: 0 0px;
	}

	.service-item {
		height: 60rpx;
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
</style>

<template>
	<view class="container">
		<!--header-->
		<view class="tui-header">
			<view class="tui-category" hover-class="opcity" :hover-stay-time="150" @tap="catalog">
				<tui-icon name="manage-fill" color="#fff" :size="44" unit="rpx"></tui-icon>
				<view class="tui-category-scale">分类</view>
			</view>
			<view class="tui-rolling-search">
				<tui-icon name="search-2" :size="32" unit="rpx"></tui-icon>
				<swiper v-if="hotKeyword.length > 0" vertical autoplay circular interval="8000" class="tui-swiper">
					<swiper-item v-for="(item, index) in hotKeyword" :key="index" class="tui-swiper-item"
						@tap="search(item.SCHEME_URL, item.KEYWORD)">
						<view class="tui-hot-item">{{ item.KEYWORD }}</view>
					</swiper-item>
				</swiper>
				<swiper v-else class="tui-swiper">
					<swiper-item class="tui-swiper-item" @tap="search()">
						<view class="tui-hot-item"></view>
					</swiper-item>
				</swiper>
			</view>
		</view>
		<!--header-->
		<view class="tui-header-banner" :style="{ height: bannerHieght + 'rpx'}">
			<view class="tui-hot-search" v-if="hotKeyword.length > 0">
				<view>热搜</view>
				<view class="tui-hot-tag" v-for="(item, index) in hotKeyword" :key="index"
					@tap="search(item.SCHEME_URL, item.KEYWORD)">{{ item.KEYWORD }}</view>
			</view>
			<!-- 轮播楼层 -->
			<view class="tui-banner-bg" v-if="banner.length > 0">
				<view class="tui-primary-bg tui-route-left"></view>
				<view class="tui-primary-bg tui-route-right"></view>
				<view class="tui-banner-box">
					<swiper :indicator-dots="true" :autoplay="true" :interval="5000" :duration="150"
						class="tui-banner-swiper" :circular="true" indicator-color="rgba(255, 255, 255, 0.8)"
						indicator-active-color="#fff">
						<swiper-item v-for="(item, index) in banner" :key="index">
							<image v-if="item.mediaType==1" :src="item.imageUrl" class="tui-slide-image"
								mode="scaleToFill" @tap.stop="toLink" :data-url="item.link" />
							<image v-if="item.mediaType===0||item.mediaType===2" :src="item.imageUrl"
								background-size="cover" :data-img="item.imageUrl" @tap.stop="previewImg"
								class="tui-slide-image" mode="scaleToFill" />

							<!-- IOS APP下视频导致页面卡顿，问题暂未找到，先隐藏 -->
							<!-- #ifndef APP-PLUS-->
							<video v-if="item.mediaType===3" class="tui-slide-image" :title="item.title"
								:src="item.videoUrl" page-gesture show-fullscreen-btn enable-play-gesture show-mute-btn
								show-screen-lock-button vslide-gesture play-btn-position="bottom" objectFit="contain" />
							<!-- #endif -->
							<!-- #ifdef APP-PLUS -->
							<image v-if="item.mediaType===3" :src="item.imageUrl" background-size="cover"
								:data-img="item.imageUrl" @tap.stop="previewImg" class="tui-slide-image"
								mode="scaleToFill" />
							<!-- #endif -->
						</swiper-item>
					</swiper>
				</view>
			</view>
		</view>
		<!-- 公众号组件 -->
		<!-- #ifdef MP-WEIXIN -->
		<official-account></official-account>
		<!-- #endif -->
		<!-- #ifdef MP-ALIPAY -->
		<lifestyle publicId="your_lifestyle_id" />
		<!-- #endif -->

		<!-- 通知楼层 -->
    <view class="tui-product-box tui-bg-white" v-if="notice.length>0" @tap="modal=true">
			<view class='tui-notice-board'>
				<view class="tui-icon-bg">
					<tui-icon tui-icon-class="tui-rolling-icon" name="news-fill" :size='24' color='#f54f46'></tui-icon>
				</view>
				<view class="tui-scorll-view">
          <view class="tui-notice tui-animation">{{notice[0].title}}</view>
				</view>
			</view>
		</view>
		<!-- channel楼层 -->
		<view class="tui-product-box tui-pb-10 tui-bg-white" v-if="category.length > 0">
			<view class="tui-product-category">
				<view class="tui-category-item" v-for="(item, index) in category" :key="index" :data-key="item.name"
					@tap="toLink" :data-url="item.url">
					<image :src="item.iconUrl" class="tui-category-img" mode="scaleToFill"></image>
					<view class="tui-category-name">{{ item.name }}</view>
				</view>
			</view>
		</view>

		<!-- 秒杀楼层 -->
    <view class="tui-product-box tui-pb-10 tui-bg-white" v-if="seckillGoods.length > 0">
			<view class="seckill-section m-t">
				<view class="s-header m-t">
					<image class="s-img" src="/static/images/mall/secskill-img.jpg" mode="widthFix"></image>
					<text class="tip">每日一款</text>
				</view>
				<view class="b">
					<view class="item" v-for="(item, index) in seckillGoods" v-if="item.show" :key="index">
						<navigator :url="'/pages/goods/goods?id=' + item.goodsId">
							<image class="img" :src="item.listPicUrl" background-size="cover"></image>
						</navigator>
						<view class="right">
							<view class="text">
								<text class="name">{{item.name}}</text>
								<text class="stock" v-if="item.stock>0">还剩{{item.stock}}件</text>
								<text class="stock" v-else>已经抢完了</text>
								<view v-if="item.stock>0" style="height: 92rpx;display: flex;align-items:center;">
									<text>{{item.text}}</text>
									<tui-countdown :time="item.totalSecond" :days="true" :isColon="false"
										backgroundColor="#333" borderColor="#333" color="#fff" />
								</view>
								<view class="price">￥{{item.price}}
									<text class="orgPrice line-through">￥{{item.marketPrice}}</text>
								</view>
                <view style="width: 400rpx;">
                  <tui-button @click="startSeckill" :custom="item.id" height="50rpx" :size="24" width="80%"
                              type="danger" shape="circle" :disabled="!item.btn">马上抢 ></tui-button>
								</view>
							</view>
						</view>
					</view>
				</view>
			</view>
		</view>
    <!--超值拼团-->
    <view class="tui-product-box tui-pb-10 tui-bg-white tui-block__box">
      <view class="tui-group-name">
        <view>
          <text>超值拼团</text>
          <text class="tui-sub__desc tui-color__pink">拼着买更便宜</text>
        </view>
        <view class="tui-more__box" @tap="toGroupList">
          <text>更多</text>
          <tui-icon name="arrowright" :size="36" unit="rpx" color="#999"></tui-icon>
        </view>
      </view>
      <scroll-view scroll-x>
        <view class="tui-goods__list">
          <view class="tui-goods__item" @tap="group(item.id)" v-for="(item, index) in groupList" :key="index"
                :data-id="item.id">
            <view class="tui-goods__imgbox">
              <image :src="item.listPicUrl" mode="widthFix" class="tui-goods__img"></image>
            </view>
            <view class="tui-pri__box">
              <view class="tui-sale-pri">
                <view class="tui-size-sm">¥</view>
                <view>{{item.groupPrice}}</view>
              </view>
            </view>
            <view class="tui-original__pri">¥{{item.retailPrice}}</view>
          </view>
        </view>
      </scroll-view>
    </view>
		<!-- 专题楼层 -->
		<view class="tui-product-box tui-pb-10 tui-bg-white" v-if="topics.length > 0">
			<view class="seckill-section m-t">
				<view class="f-header m-t">
					<image src="/static/images/mall/topic.png"></image>
					<view class="tit-box">
						<text class="tit">专题</text>
						<text class="tit2">Topic</text>
					</view>
				</view>
				<scroll-view class="floor-list" scroll-x>
					<view class="scoll-wrapper">
						<view v-for="(item, index) in topics" :key="index" class="floor-item" @tap="toLink"
							:data-url="'../topicDetail/topicDetail?id='+item.id">
							<image :src="item.itemPicUrl" mode="aspectFill"></image>
							<text class="title clamp">{{ item.title }}</text>
						</view>
						<view @tap="toLink" :data-url="'../topic/topic'">
							<view class="more">
								<text>查看全部</text>
								<text>More+</text>
							</view>
						</view>
					</view>
				</scroll-view>
			</view>
		</view>
		<!-- 品牌制造商楼层 -->
		<view class="tui-product-box tui-pb-10 tui-bg-white" v-if="brand.length > 0">
			<view class="seckill-section m-t">
				<view class="tui-group-name" :data-url="'/pages/brand/brand'" @tap="toLink">
					<text>品牌制造商</text>
					<tui-icon name="arrowright" :size="42" unit="rpx" color="#555"></tui-icon>
				</view>
				<scroll-view class="floor-list" scroll-x>
					<view class="scoll-wrapper">
						<view v-for="(item, index) in brand" :data-url="'/pages/category/category?brandId='+item.id"
							:key="index" class="floor-item" @tap="toLink">
							<image :src="item.listPicUrl" mode="aspectFill"></image>
							<text class="title clamp">{{ item.name }}</text>
							<text class="price">￥{{ item.floorPrice }}</text>元起
						</view>
						<navigator url="../brand/brand">
							<view class="more">
								<text>查看全部</text>
								<text>More+</text>
							</view>
						</navigator>
					</view>
				</scroll-view>
			</view>
		</view>
		<!-- 新品推荐 -->
		<view class="tui-product-box tui-pb-10 tui-bg-white">
			<view class="tui-group-name" @tap="goCategory">
				<text>新品推荐</text>
				<tui-icon name="arrowright" :size="42" unit="rpx" color="#555"></tui-icon>
			</view>
			<view class="tui-new-box">
				<view class="tui-new-item" :class="[index != 0 && index != 1 ? 'tui-new-mtop' : '']"
					v-for="(item, index) in newProduct" :key="index" :data-id="item.id" @tap="navToGoodsDetail">
					<image :src="'/static/images/mall/' + (item.type == 1 ? 'new' : 'discount') + '.png'"
						class="tui-new-label" v-if="item.isLabel"></image>
					<image src="/static/images/mall/new.png" class="tui-new-label"></image>
					<view class="tui-title-box">
						<view class="tui-new-title">{{ item.name }}</view>
						<view class="tui-new-price">
							<text class="tui-new-present">￥{{ item.retailPrice }}</text>
							<text class="tui-new-original">￥{{ item.marketPrice }}</text>
						</view>
					</view>
					<image :src="item.listPicUrl" class="tui-new-img"></image>
				</view>
			</view>
		</view>

		<!-- 热门推荐 -->
		<view class="tui-product-box">
			<view class="tui-group-name"><text>热门推荐</text></view>
			<view class="tui-product-list">
				<view class="tui-product-container">
					<block v-for="(item, index) in productList" :key="index" v-if="(index + 1) % 2 != 0">
						<!--商品列表-->
						<view class="tui-pro-item" hover-class="hover" :hover-start-time="150" :data-id="item.id"
							@tap="navToGoodsDetail">
							<image :src="item.listPicUrl" class="tui-pro-img" mode="widthFix" />
							<view class="tui-pro-content">
								<view class="tui-pro-tit">{{ item.name }}</view>
								<view>
									<view class="tui-pro-price">
										<text class="tui-sale-price">￥{{ item.retailPrice }}</text>
										<text class="tui-factory-price">￥{{ item.marketPrice }}</text>
									</view>
									<view class="tui-pro-pay">{{ item.sales||0 }}人付款</view>
								</view>
							</view>
						</view>
					</block>
				</view>
				<view class="tui-product-container">
					<block v-for="(item, index) in productList" :key="index" v-if="(index + 1) % 2 == 0">
						<!--商品列表-->
						<view class="tui-pro-item" hover-class="hover" :hover-start-time="150" :data-id="item.id"
							@tap="navToGoodsDetail">
							<image :src="item.listPicUrl" class="tui-pro-img" mode="widthFix" />
							<view class="tui-pro-content">
								<view class="tui-pro-tit">{{ item.name }}</view>
								<view>
									<view class="tui-pro-price">
										<text class="tui-sale-price">￥{{ item.retailPrice }}</text>
										<text class="tui-factory-price">￥{{ item.marketPrice }}</text>
									</view>
									<view class="tui-pro-pay">{{ item.sales||0 }}人付款</view>
								</view>
							</view>
						</view>
					</block>
				</view>
			</view>
		</view>
		<!-- #ifdef MP-WEIXIN -->
		<tui-scroll-top :bottom="20" :scrollTop="scrollTop" isShare></tui-scroll-top>
		<!-- #endif -->
		<!-- #ifdef APP-PLUS || H5 -->
		<tui-scroll-top :scrollTop="scrollTop"></tui-scroll-top>
		<tui-fab :width="80" :height="80" :right="30" :bottom="200" icon="share" @click="onShare"></tui-fab>
		<!-- #endif -->
		<tui-nomore bgcolor="#fff" visible></tui-nomore>
		<view class="message-box-wrapper" v-if="luckdrawVisit">
			<view class="message-box">
				<Luckdraw></Luckdraw>
				<tui-button @click="luckdrawVisit=false" type="white" link plain>x</tui-button>
			</view>
		</view>
    <tui-modal :show="modal" maskClosable custom zIndex="9999" width="90%" @cancel="modal=false">
      <view>
        <view class="notice-title">公告</view>
        <uParse :content="notice[0].content" noData=" " />
      </view>
    </tui-modal>
	</view>
</template>
<script>
	import Luckdraw from '../luckdraw/luckdraw';
	const util = require("@/utils/util.js");
	const app = getApp();
  import uParse from '@/components/uni/uParse/src/wxParse'

	export default {
		data() {
			return {
        modal: false,
				luckdrawVisit: false,
				latitude: '',
				longitude: '',
				notice: '',
				hotKeyword: [],
				banner: [],
				bannerHieght: 0,
				category: [],
				topics: [],
				brand: [],
				newProduct: [],
				productList: [],
        groupList: [],
				seckillGoods: [{
					text: ''
				}],
				tmplIds: [],
				scrollTop: 0
			};
		},
		components: {
			Luckdraw, uParse
		},
		methods: {
			onShare() {
				//#ifdef APP-PLUS
				let that = this
				plus.share.getServices(function(s) {
					var shares = {};
					for (var i = 0; i < s.length; i++) {
						var t = s[i];
						shares[t.id] = t;
					}
					let sweixin = shares['weixin']
					if (!sweixin) {
						plus.nativeUI.alert('当前环境不支持微信分享操作!');
					} else {
						// 发送分享
						uni.share({
							provider: 'weixin',
							scene: "WXSceneSession",
							type: 5,
							imageUrl: 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/gh_9f71054867af_860.jpg',
							title: '美好购物从这里开始',
							miniProgram: {
								id: util.maAppId,
								path: 'pages/index/index',
								type: 0,
								webUrl: 'http://fly2you.cn'
							},
							success: ret => {
								console.log(JSON.stringify(ret));
							}
						});
					}
				}, function(e) {
					console.log("获取分享服务列表失败：" + e.message);
				});
				//#endif
				// #ifdef H5
				location.href = "http://fly2you.cn/"
				// #endif
			},
			getIndexData: function() {
				uni.setStorageSync("navUrl", "/pages/index/index");
				let that = this
				util.request('search/hotKeyword').then(function(res) {
					if (res.code === 0) {
						that.hotKeyword = res.hotKeywordList
					}
				});
				util.request('index/bannerList').then(function(res) {
					if (res.code === 0) {
						that.banner = res.data
						if (that.banner.length > 0) {
							that.bannerHieght = 580;
							// #ifdef H5
							that.bannerHieght = 620;
							// #endif
						}
					}
				});
				util.request('index/bulletinList').then(function(res) {
					if (res.code === 0) {
						that.notice = res.data
					}
				});
				util.request('index/channelList').then(function(res) {
					if (res.code === 0) {
						that.category = res.data
					}
				});
				util.request('topic/list').then(res => {
					if (res.code === 0) {
						that.topics = res.data.records
					}
				});
				util.request('seckill/list').then(function(res) {
					if (res.code === 0) {
						//获取待付款倒计时
						res.data.forEach((item) => {
							item.show = true;
							item.btn = false;
							that.countdown(item)
						})
						that.seckillGoods = res.data
					}
				});
				util.request('brand/brandList').then(function(res) {
					if (res.code === 0) {
						that.brand = res.data.records
						// 同时最多不能超过10个请求
						util.request('goods/list', {
							type: 'IS_HOT'
						}).then(function(res) {
							if (res.code === 0) {
								that.productList = res.data.records
							}
						});
						util.request('goods/list', {
							type: 'IS_NEW'
						}).then(function(res) {
							if (res.code === 0) {
								that.newProduct = res.data.records
							}
						});
            util.request('goods/list', {
              type: 'IS_GROUP'
            }).then(function(res) {
              if (res.code === 0) {
                that.groupList = res.data.records
              }
            });
					}
				});
			},
			startSeckill: function(e) {
				let that = this;
				// #ifdef MP-WEIXIN
				uni.requestSubscribeMessage({
					tmplIds: that.tmplIds,
					success(res) {

					},
					fail(res) {

					},
					complete() {
						util.request('seckill/startSeckill', {
							seckillId: e.custom,
							fromType: util.getFromType()
						}, 'POST', 'application/json').then(res => {
							if (res.code === 0) {
								//存储用户信息
								util.toast(res.msg);
								uni.navigateTo({
									url: '/pages/ucenter/skillDetail/skillDetail?id=' + res.orderId
								})
							} else {
								util.toast(res.msg);
							}
						});
					}
				})
				// #endif
				// #ifndef MP-WEIXIN
				util.request('seckill/startSeckill', {
					seckillId: e.custom,
					fromType: util.getFromType()
				}, 'POST', 'application/json').then(res => {
					if (res.code === 0) {
						//存储用户信息
						util.toast(res.msg);
						uni.navigateTo({
							url: '/pages/ucenter/skillDetail/skillDetail?id=' + res.orderId
						})
					} else {
						util.toast(res.msg);
					}
				});
				// #endif
			},
			//todo 订单列表页面使用有bug
			countdown: function(seckillGood) {
				let that = this;
				let EndTime = seckillGood.endTime || [];
				let StartTime = seckillGood.startTime || [];
				let NowTime = new Date().getTime();
				let para = {};

				let willEnd = false;
				if (Date.parse(StartTime.replace(/-/g, '/')) < new Date()) {
					seckillGood.text = '距结束：'
					willEnd = true;
					if (seckillGood.stock > 0) {
						seckillGood.btn = true;
					}
				} else if (Date.parse(StartTime.replace(/-/g, '/')) > new Date()) {
					seckillGood.text = '距开始：'
					EndTime = StartTime
					seckillGood.btn = false;
				}

				//IOS系统直接使用new Date('2018-10-29 11:25:21')，在IOS上获取不到对应的时间对象。
				let totalSecond = Date.parse(EndTime.replace(/-/g, '/')) - NowTime || [];

				seckillGood.totalSecond = totalSecond / 1000

				if (totalSecond <= 0 && willEnd) {
					seckillGood.show = false
					return;
				}
				setTimeout(function() {
					totalSecond -= 1000;
					that.countdown(seckillGood);
				}, 1000)
			},
			toLink: function(e) {
				uni.navigateTo({
					url: e.currentTarget.dataset.url
				});
			},
			navToGoodsDetail: function(e) {
				uni.navigateTo({
					url: '/pages/goods/goods?id=' + e.currentTarget.dataset.id
				});
			},
			//放大预览轮播图片
			previewImg: function(e) {
				let curImg = e.currentTarget.dataset.img;
				let banner = this.banner;
				if (!util.isEmpty(curImg) && banner.length > 0) {
					let imgsArr = [];
					for (let i = 0; i < banner.length; i++) {
						imgsArr[i] = banner[i].imageUrl;
					}
					uni.previewImage({
						current: curImg, // 当前显示图片的http链接
						urls: imgsArr, // 需要预览的图片http链接列表
					})
				}
			},
			openCall: function(e) {
				uni.makePhoneCall({
					phoneNumber: e.target.dataset.phone
				})
			},
			goHere: function(e) {
				uni.openLocation({
					name: e.currentTarget.dataset.name,
					address: e.currentTarget.dataset.address,
					latitude: parseFloat(e.currentTarget.dataset.latitude),
					longitude: parseFloat(e.currentTarget.dataset.longitude)
				})
			},
			catalog: function() {
				uni.reLaunch({
					url: '../catalog/catalog'
				});
			},
			goCategory: function(id, pId) {
				uni.navigateTo({
					url: '/pages/category/category?type=IS_NEW'
				})
			},
			search: function(url, keyword) {
				if (url) {
					uni.navigateTo({
						url: url
					})
				} else {
					uni.navigateTo({
						url: '/pages/category/category?keyword=' + keyword
					});
				}
			},
      toGroupList() {
        uni.navigateTo({
          url: '/pages/groupList/groupList'
        });
      },
      group(id) {
        uni.navigateTo({
          url: '/pages/groupDetail/groupDetail?id=' + id
        });
      }
		},
		onShow: function() {
			// 页面显示
			let that = this;

			// #ifdef MP-WEIXIN
			util.request('index/getTemplateId', {
				templateTypes: '4,5'
			}).then(res => {
				if (res.code === 0) {
					that.tmplIds = res.data
				}
			});
			// #endif
		},
		onLoad: function() {
			this.getIndexData()
			// #ifdef MP-WEIXIN
			uni.showShareMenu({
				withShareTicket: true,
				menus: ['shareAppMessage', 'shareTimeline']
			})
			// #endif
		},
		onPageScroll(e) {
			this.scrollTop = e.scrollTop
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			this.getIndexData();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		onShareTimeline: function() {
			return {
				title: util.projectName,
				path: '/pages/index/index'
			}
		},
		onShareAppMessage: function() {
			return {
				title: util.projectName,
				path: '/pages/index/index'
			}
		}
	};
</script>

<style>
	page {
		background-color: #f7f7f7;
	}

	.container {
		overflow-x: hidden;
		padding-bottom: 50rpx;
		color: #333;
	}

	.tui-header {
		width: 100%;
		height: 100rpx;
		padding: 0 30rpx 0 20rpx;
		box-sizing: border-box;
		background-color: #e41f19;
		display: flex;
		align-items: center;
		justify-content: space-between;
		position: fixed;
		left: 0;
		top: 0;
		/* #ifdef H5 */
		top: 44px;
		/* #endif */
		z-index: 999;
	}

	.tui-rolling-search {
		width: 100%;
		height: 60rpx;
		border-radius: 35rpx;
		padding: 0 40rpx 0 30rpx;
		box-sizing: border-box;
		background-color: #fff;
		display: flex;
		align-items: center;
		flex-wrap: nowrap;
		color: #999;
	}

	.tui-category {
		font-size: 24rpx;
		color: #fff;
		display: flex;
		align-items: center;
		justify-content: center;
		flex-direction: column;
		margin: 0;
		margin-right: 22rpx;
		flex-shrink: 0;
	}

	.tui-category-scale {
		transform: scale(0.7);
		line-height: 24rpx;
	}

	.tui-icon-category {
		line-height: 20px !important;
		margin-bottom: 0 !important;
	}

	.tui-swiper {
		font-size: 26rpx;
		height: 60rpx;
		flex: 1;
		padding-left: 12rpx;
	}

	.tui-swiper-item {
		display: flex;
		align-items: center;
	}

	.tui-hot-item {
		font-size: 22rpx;
		line-height: 26rpx;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.tui-header-banner {
		padding-top: 100rpx;
		box-sizing: border-box;
		background: #e41f19;
	}

	.tui-hot-search {
		color: #fff;
		font-size: 24rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 0 20rpx;
		box-sizing: border-box;
		position: relative;
		z-index: 2;
	}

	.tui-hot-tag {
		font-size: 22rpx;
		background-color: rgba(255, 255, 255, 0.15);
		padding: 10rpx 24rpx;
		border-radius: 30rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		line-height: 24rpx;
	}

	.tui-banner-bg {
		display: flex;
		height: 340rpx;
		/* #ifdef H5 */
		height: 380rpx;
		/* #endif */
		background-color: #e41f19;
		position: relative;
	}

	.tui-primary-bg {
		width: 50%;
		display: inline-block;
		height: 224rpx;
		border: 1px solid transparent;
		position: relative;
		z-index: 1;
		background-color: #e41f19;
	}

	.tui-route-left {
		transform: skewY(8deg);
	}

	.tui-route-right {
		transform: skewY(-8deg);
	}

	.tui-banner-box {
		width: 100%;
		padding: 0 20rpx;
		box-sizing: border-box;
		position: absolute;
		/* overflow: hidden; */
		z-index: 99;
		bottom: -80rpx;
		left: 0;
	}

	.tui-banner-swiper {
		width: 100%;
		height: 400rpx;
		/* #ifdef H5 */
		height: 440rpx;
		/* #endif */
		border-radius: 12rpx;
		overflow: hidden;
		transform: translateY(0);
	}

	.tui-slide-image {
		width: 100%;
    height: 400rpx;
		display: block;
	}

	/* #ifdef MP-WEIXIN */
	.tui-banner-swiper .wx-swiper-dot {
		width: 8rpx;
		height: 8rpx;
		display: inline-flex;
		background: none;
		justify-content: space-between;
	}

	.tui-banner-swiper .wx-swiper-dot::before {
		content: '';
		flex-grow: 1;
		background-color: rgba(255, 255, 255, 0.8);
		border-radius: 16rpx;
		overflow: hidden;
	}

	.tui-banner-swiper .wx-swiper-dot-active::before {
		background-color: #fff;
	}

	.tui-banner-swiper .wx-swiper-dot.wx-swiper-dot-active {
		width: 16rpx;
	}

	/* #endif */

	/* #ifndef MP-WEIXIN */
	>>>.tui-banner-swiper .uni-swiper-dot {
		width: 8rpx;
		height: 8rpx;
		display: inline-flex;
		background-color: none;
		justify-content: space-between;
	}

	>>>.tui-banner-swiper .uni-swiper-dot::before {
		content: '';
		flex-grow: 1;
		background-color: rgba(255, 255, 255, 0.8);
		border-radius: 16rpx;
		overflow: hidden;
	}

	>>>.tui-banner-swiper .uni-swiper-dot-active::before {
		background-color: #fff;
	}

	>>>.tui-banner-swiper .uni-swiper-dot.uni-swiper-dot-active {
		width: 16rpx;
	}

	/* #endif */

	/* 秒杀专区 */
	.seckill-section {
		margin-top: 10rpx;
		background: #fff;
	}

	.seckill-section .s-header {
		padding: 0 0 0 30rpx;
		display: flex;
		align-items: center;
		height: 92rpx;
		line-height: 1;
	}

	.seckill-section .s-header .s-img {
		width: 140rpx;
		height: 30rpx;
	}

	.seckill-section .s-header .tip {
		font-size: 28rpx;
		color: #909399;
		margin: 0 20rpx 0 40rpx;
	}

	.seckill-section .floor-list {
		white-space: nowrap;
	}

	.seckill-section .scoll-wrapper {
		display: flex;
		align-items: flex-start;
	}

	.seckill-section .floor-item {
		width: 250rpx;
		margin-right: 20rpx;
		font-size: 26rpx;
		color: #303133;
		line-height: 1.8;
	}

	.seckill-section .floor-item image {
		width: 250rpx;
		height: 250rpx;
		border-radius: 6rpx;
	}

	.seckill-section .floor-item .price {
		font-size: 28rpx;
		font-weight: bold;
		color: #e41f19;
	}

	.seckill-section .more {
		display: flex;
		align-items: center;
		justify-content: center;
		flex-direction: column;
		flex-shrink: 0;
		width: 250rpx;
		height: 250rpx;
		border-radius: 20rpx;
		background: #f3f3f3;
		font-size: 24rpx;
		color: #909399;
	}

	.f-header {
		margin-top: 10rpx;
		display: flex;
		align-items: center;
		height: 140rpx;
		padding: 6rpx 30rpx 8rpx;
		background: #fff;
	}

	.f-header image {
		flex-shrink: 0;
		width: 80rpx;
		height: 80rpx;
		margin-right: 20rpx;
	}

	.f-header .tit-box {
		flex: 1;
		display: flex;
		flex-direction: column;
	}

	.f-header .tit {
		font-size: 34rpx;
		color: #303133;
		line-height: 1.3;
	}

	.f-header .tit2 {
		font-size: 24rpx;
		color: #909399;
	}

	.clamp {
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
		display: block;
	}

	.floor-item image {
		width: 150rpx;
		height: 150rpx;
		border-radius: 20rpx;
	}

	.line-through {
		display: inline;
		color: rgb(153, 153, 153);
		font-size: 23rpx;
		text-decoration: line-through;
	}

	.more {
		display: flex;
		align-items: center;
		justify-content: center;
		flex-direction: column;
		flex-shrink: 0;
		width: 180rpx;
		height: 180rpx;
		border-radius: 6rpx;
		background: #f3f3f3;
		font-size: 24rpx;
		color: #909399;
	}


	/* 通知楼层 */
	.tui-notice-board {
		width: 100%;
		box-sizing: border-box;
		font-size: 24rpx;
		display: flex;
		align-items: center;
		top: 0;
		z-index: 999;
	}

	.tui-icon-bg {
		position: relative;
		z-index: 10;
	}

	.tui-rolling-icon {
		margin-right: 12rpx;
	}

	.tui-scorll-view {
		flex: 1;
		line-height: 1;
		white-space: nowrap;
		overflow: hidden;
		color: #f54f46;
	}

	.tui-notice {
		transform: translateX(100%);
	}

	.tui-animation {
		-webkit-animation: tui-rolling 12s linear infinite;
		animation: tui-rolling 12s linear infinite;
	}

	@-webkit-keyframes tui-rolling {
		0% {
			transform: translateX(100%);
		}

		100% {
			transform: translateX(-170%);
		}
	}

	@keyframes tui-rolling {
		0% {
			transform: translateX(100%);
		}

		100% {
			transform: translateX(-170%);
		}
	}

	.tui-product-category {
		background-color: #fff;
		padding: 20rpx;
		box-sizing: border-box;
		display: flex;
		align-items: center;
		justify-content: space-between;
		flex-wrap: wrap;
		font-size: 24rpx;
		color: #555;
	}

	.tui-category-item {
		width: 20%;
		height: 118rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
		flex-direction: column;
		padding-top: 30rpx;
	}

	.tui-category-img {
		height: 80rpx;
		width: 80rpx;
		display: block;
	}

	.tui-category-name {
		line-height: 24rpx;
	}

	.tui-product-box {
		margin-top: 20rpx;
		padding: 0 20rpx;
    border-radius: 30rpx;
		box-sizing: border-box;
	}

  .tui-block__box {
    padding: 0 25rpx 25rpx;
    box-sizing: border-box;
    background-color: #ffffff;
    border-radius: 20rpx;
    overflow: hidden;
  }

	.tui-pb-10 {
		padding-bottom: 10rpx;
	}

	.tui-bg-white {
		background-color: #fff;
	}

  .tui-group-name {
    width: 100%;
    font-size: 34rpx;
    line-height: 34rpx;
    font-weight: bold;
    text-align: center;
    padding: 30rpx 0;
    display: flex;
    align-items: center;
    justify-content: space-between;
    color: #333;
  }

  .tui-sub__desc {
    color: #34c7a9;
    font-size: 28rpx;
    font-weight: 400;
    padding-left: 25rpx;
  }

  .tui-color__pink {
    color: #EF1346;
  }

  .tui-goods__list {
    display: flex;
    align-items: center;
  }

  .tui-goods__item {
    background-color: #fff;
    width: 150rpx;
    height: 230rpx;
    border-radius: 6rpx;
    box-sizing: border-box;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    flex-shrink: 0;
    margin-right: 18rpx;
  }

  .tui-goods__imgbox {
    width: 150rpx;
    height: 150rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    box-sizing: border-box;
  }

  .tui-goods__img {
    max-width: 150rpx;
    max-height: 150rpx;
    display: block;
  }

  .tui-pri__box {
    max-width: 150rpx;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .tui-sale-pri {
    display: flex;
    align-items: flex-end;
    padding: 10rpx 0 8rpx;
    box-sizing: border-box;
    font-size: 28rpx;
    line-height: 28rpx;
    color: #eb0909;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }

  .tui-size-sm {
    font-size: 24rpx;
    line-height: 24rpx;
    transform: scale(0.8);
    transform-origin: 0 50%;
  }

  .tui-original__pri {
    font-size: 24rpx;
    line-height: 24rpx;
    color: #999999;
    transform-origin: center 10%;
    transform: scale(0.8);
    display: flex;
    align-items: center;
    justify-content: center;
    text-decoration: line-through;
  }

  /*秒杀商品*/
  .tui-more__box {
    display: flex;
    align-items: center;
    font-weight: 400;
    color: #999;
  }

  .tui-more__box text {
    font-size: 24rpx;
    line-height: 24rpx;
  }

	.tui-new-box {
		display: flex;
		align-items: center;
		justify-content: space-between;
		flex-wrap: wrap;
	}

	.tui-new-item {
		width: 49%;
		height: 200rpx;
		padding: 0 20rpx;
		box-sizing: border-box;
		display: flex;
		align-items: center;
		background: #f5f2f9;
		position: relative;
		border-radius: 12rpx;
	}

	.tui-new-mtop {
		margin-top: 2%;
	}

	.tui-title-box {
		font-size: 24rpx;
	}

	.tui-new-title {
		line-height: 32rpx;
		word-break: break-all;
		overflow: hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
	}

	.tui-new-price {
		padding-top: 18rpx;
	}

	.tui-new-present {
		color: #ff201f;
		font-weight: bold;
	}

	.tui-new-original {
		display: inline-block;
		color: #a0a0a0;
		text-decoration: line-through;
		padding-left: 12rpx;
		transform: scale(0.8);
		transform-origin: center center;
	}

	.tui-new-img {
		width: 160rpx;
		height: 160rpx;
		display: block;
		flex-shrink: 0;
	}

	.tui-new-label {
		width: 56rpx;
		height: 56rpx;
		border-top-left-radius: 12rpx;
		position: absolute;
		left: 0;
		top: 0;
	}

	.tui-product-list {
		display: flex;
		justify-content: space-between;
		flex-direction: row;
		flex-wrap: wrap;
		box-sizing: border-box;
		/* padding-top: 20rpx; */
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

  .b .item {
    border-top: 1px solid #d9d9d9;
    height: 264rpx;
  }

  .b .img {
    margin-top: 12rpx;
    margin-right: 12rpx;
    float: left;
    width: 200rpx;
    height: 200rpx;
    border-radius: 25rpx;
  }

  .b .right {
    float: left;
    height: 264rpx;
    width: 456rpx;
    display: flex;
    flex-flow: row nowrap;
  }

  .b .text {
    margin: 10rpx;
    font-size: 20rpx;
    display: flex;
    flex-wrap: nowrap;
    flex-direction: column;
    justify-content: center;
    overflow: hidden;
    height: 244rpx;
  }

  .b .name {
    display: block;
    color: #333;
  }

  .b .stock {
    color: #E41F19;
  }

  .b .price {
    display: block;
    color: #E41F19;
    line-height: 50rpx;
    font-size: 38rpx;
  }

  .notice-title {
    text-align: center;
    font-weight: bolder;
    padding-bottom: 30rpx
  }
</style>

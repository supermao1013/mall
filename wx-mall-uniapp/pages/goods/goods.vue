<template>
	<view class="container">
    <!-- #ifndef MP-ALIPAY -->
		<!--header-->
		<view class="tui-header-box" :style="{ height: height + 'px', background: 'rgba(255,255,255,' + opcity + ')' }">
			<view class="tui-header" :style="{ paddingTop: top + 'px', opacity: opcity }">商品详情</view>
      <view class="tui-header-icon" :style="{ marginTop: top + 'px' }">
        <view class="tui-icon-box" :style="{ backgroundColor: 'rgba(0, 0, 0,' + iconOpcity + ')' }" @tap="back">
          <tui-icon name="arrowleft" :size="30" :color="opcity >= 1 ? '#000' : '#fff'"></tui-icon>
        </view>
        <view class="tui-icon-box tui-icon-ml" :style="{backgroundColor: 'rgba(0, 0, 0,' + iconOpcity + ')'}"
              @tap.stop="openMenu">
          <tui-icon name="more-fill" :size="20" :color="opcity >= 1 ? '#000' : '#fff'"></tui-icon>
        </view>
      </view>
		</view>
		<!--header-->
    <!-- #endif -->

		<tui-fadeinout v-if="historyList.length >0" title="nickname" img="headImgUrl" :loop="false" :top="historyTop"
			:list="historyList"></tui-fadeinout>
		<!--顶部下拉菜单-->
    <tui-top-dropdown backgroundColor="rgba(76, 76, 76, 0.95)" :show="menuShow" :height="0" @close="closeMenu">
      <view class="tui-menu-box tui-padding tui-ptop">
				<view class="tui-menu-header" :style="{paddingTop: top + 'px;'}">
					功能直达
				</view>
				<view class="tui-menu-itembox">
					<block>
						<view class="tui-menu-item" hover-class="tui-opcity" hover-stay-time="150" @tap="switchNav"
							data-name="index">
							<view class="tui-badge-box">
								<tui-icon name="home" color="#fff" :size="23"></tui-icon>
							</view>
							<view class="tui-menu-text">首页</view>
						</view>
					</block>
          <block>
            <view class="tui-menu-item" hover-class="tui-opcity" hover-stay-time="150" @tap="person"
                  data-name="index">
              <view class="tui-badge-box">
                <tui-icon name="people" color="#fff" :size="23"></tui-icon>
              </view>
              <view class="tui-menu-text">我的</view>
            </view>
          </block>
					<block>
						<view class="tui-menu-item" hover-class="tui-opcity" hover-stay-time="150" @tap="showShare">
							<view class="tui-badge-box">
								<tui-icon name="share" color="#fff" :size="26"></tui-icon>
							</view>
							<view class="tui-menu-text">分享</view>
						</view>
					</block>
					<block>
						<view class="tui-menu-item" hover-class="tui-opcity" :hover-stay-time="150" @tap="feedback">
							<view class="tui-badge-box">
								<tui-icon name="feedback" color="#fff" :size="23"></tui-icon>
							</view>
							<view class="tui-menu-text">我要反馈</view>
						</view>
					</block>
				</view>
				<tui-icon name="up" color="#fff" :size="26" class="tui-icon-up" @click="closeMenu"></tui-icon>
			</view>
		</tui-top-dropdown>
		<!---顶部下拉菜单-->
		<scroll-view class="container" scroll-y="true">
			<view v-if="showNavList" class="modal-wrap"></view>
			<view class="fast-nav">
				<!-- #ifdef MP-WEIXIN -->
				<button v-if="!showNavList" class="contact" open-type="contact" :send-message-title="goods.name"
					:send-message-img="gallery[0]" :send-message-path="'/pages/goods/goods?id=' + id"
					:show-message-card="true" plain size="25" session-from="weapp">
					<text class='icon chat'></text>
				</button>
				<!-- #endif -->
				<view v-if="!showNavList" class="nav" @tap="toggleNav">
					<text>快捷</text>
					<text>导航</text>
				</view>
				<view class="nav-list" v-if="showNavList">
					<view class="nav-item">
						<text class="nav-text">首页</text>
						<view class="nav-cell" @tap="switchNav" data-name="index">
							<image src="../../static/images/mall/index.png"></image>
						</view>
					</view>
					<view class="nav-item">
						<text class="nav-text">足迹</text>
						<navigator class="nav-cell" url="../ucenter/footprint/footprint">
							<image src="../../static/images/mall/icon_footprint.png"></image>
						</navigator>
					</view>
					<view class="nav-item">
						<text class="nav-text">搜索</text>
						<navigator class="nav-cell" url="/pages/category/category">
							<image src="../../static/images/mall/search_2x.png"></image>
						</navigator>
					</view>
					<view class="nav-item">
						<text class="nav-text">购物车</text>
						<view class="nav-cell" @tap="switchNav" data-name="cart">
							<image src="../../static/images/mall/cart.png"></image>
						</view>
					</view>
				</view>
				<image src="../../static/images/mall/icon_popup_closed.png" v-if="showNavList" background-size="cover"
					class="close" @tap="toggleNav"></image>
			</view>
			<view>
        <view class="tui-banner-swiper">
          <swiper class="goodsimgs" indicator-dots="true" autoplay="true" interval="3000" duration="1000" @change="bannerChange">
            <swiper-item v-for="(item, index) in gallery" :key="index">
              <image class="list" :src="item.url" background-size="cover" :data-img="item.url"
                     @tap="previewImg"></image>
            </swiper-item>
          </swiper>
          <view class="tui-video__box" @tap.stop="play(goods.videoUrl)" v-if="goods.videoUrl">
            <image src="../../static/images/mall/img_video_3x.png" mode="widthFix"></image>
            <view>00′40″</view>
          </view>
          <view class="tui-banner-tag">
            <tui-tag padding="12rpx 18rpx" type="translucent" shape="circleLeft" :scaleMultiple="0.82"
                     originRight>{{ bannerIndex + 1 }}/{{ gallery.length }}</tui-tag>
          </view>
        </view>

				<view class="tui-pro-detail">
					<view class="tui-product-title tui-border-radius">
						<view class="tui-pro-pricebox tui-padding">
							<view class="tui-pro-price">
								<view>
									<text>￥</text>
									<text class="tui-price">{{goods.retailPrice||''}}</text>
								</view>
								<tui-tag v-if="goods.isNew == 1" padding="10rpx 20rpx" size="24rpx" plain
									type="high-green" shape="circle" :scaleMultiple="0.8">新品</tui-tag>
							</view>
							<view v-if="goods.shopsName" class="tui-collection tui-size brand" @tap="switchShops()">
								<text>{{goods.shopsName}}</text>
							</view>
						</view>
						<view class="tui-original-price tui-gray">
							价格
							<text class="tui-line-through">￥{{goods.marketPrice||''}}</text>
						</view>
						<view class="tui-pro-titbox">
							<view class="tui-pro-title">{{goods.name||''}}</view>
							<button class="tui-share-btn tui-share-position" @tap="showShare">
								<tui-tag type="gray" shape="circleLeft" padding="12rpx 16rpx">
									<view class="tui-share-box">
										<tui-icon name="partake" color="#999" :size="15"></tui-icon>
										<text class="tui-share-text tui-gray tui-size">分享</text>
									</view>
								</tui-tag>
							</button>
						</view>
						<view class="tui-padding">
							<view class="tui-sub-title tui-size tui-gray">{{goods.goodsBrief}}</view>
							<view class="tui-sale-info tui-size tui-gray">
								<view>在线支付满88元免运费</view>
								<view>起售数量：{{goods.minSell||1}}</view>
								<view>销量：{{goods.sales||0}}</view>
							</view>
						</view>
					</view>
				</view>

        <view class="tui-discount-box tui-radius-all tui-mtop">
          <view class="tui-list-cell" @tap="coupon">
            <view class="tui-bold tui-cell-title">领券</view>
            <view class="tui-flex-center">
              <tui-tag v-for="(item,index) in couponList" :key="index" type="red" shape="circle" padding="12rpx 24rpx"
                       margin="0 10rpx" size="24rpx">
                <text v-if="item.couponType==1">满{{item.minPrice}}元减{{item.subPrice}}</text>
                <text v-if="item.couponType==2">满{{item.minPrice}}元折扣{{item.discount}}</text>
              </tui-tag>
            </view>
            <view class="tui-ml-auto">
              <tui-icon name="more-fill" :size="20" color="#666"></tui-icon>
            </view>
          </view>
        </view>
        <view class="tui-basic-info tui-mtop tui-radius-all">
          <view class="tui-list-cell tui-last">
            <view class="tui-bold tui-cell-title">运费</view>
            <view class="tui-selected-box">在线支付满{{shippingFeeFree}}元免运费</view>
          </view>
        </view>

				<view class="tui-basic-info tui-mtop tui-radius-all">
					<view class="tui-list-cell" @tap="switchAttrPop">
						<view class="tui-bold tui-cell-title">已选</view>
						<view class="tui-selected-box">{{selected}}</view>
						<view class="tui-ml-auto">
							<tui-icon name="more-fill" :size="20" color="#666"></tui-icon>
						</view>
					</view>
				</view>

				<view class="tui-cmt-box tui-mtop tui-radius-all" v-if="comment.count > 0">
					<view class="tui-list-cell tui-last tui-between">
						<view class="tui-bold tui-cell-title">评价({{comment.count > 100 ? '100+' : comment.count}})
						</view>
						<view class="tui-flex-center" @click="commonDetail(goods.id)">
							<text class="tui-cmt-all">查看全部</text>
							<tui-icon name="more-fill" :size="20" color="#ff201f"></tui-icon>
						</view>
					</view>
					<view class="tui-cmt-content tui-padding">
						<view class="tui-cmt-user">
							<image :src="comment.data.headImgUrl" class="tui-acatar"></image>
							<view>{{comment.data.nickname}}</view>
						</view>
						<view class="tui-cmt">{{comment.data.content}}</view>
						<view v-if="comment.data.picList.length > 0">
							<image class="img" v-for="(item, index) in comment.data.picList" @tap="previewPic"
								:data-index="index" :data-urls="comment.data.picList" :key="index" :src="item.picUrl">
							</image>
						</view>
						<view class="tui-attr" v-if="comment.data.goodsSpecifitionNameValue">
							{{comment.data.goodsSpecifitionNameValue}}
						</view>
					</view>

					<view class="tui-cmt-btn">
						<tui-button width="240rpx" height="64rpx" :size="24" type="black" plain shape="circle"
							@click="commonDetail(goods.id)">查看全部评价</tui-button>
					</view>
				</view>
				<view class="tui-nomore-box">
					<tui-nomore text="宝贝详情" backgroundColor="#fafafa"></tui-nomore>
				</view>
				<view class="goods-attr" v-if="attribute.length>0">
					<view class="t">商品参数</view>
					<view class="l">
						<view class="item" v-for="(item, index) in attribute" :key="index">
							<text class="left">{{item.attributeName||''}}</text>
							<text class="right">{{item.value||''}}</text>
						</view>
					</view>
				</view>

				<view class="detail">
					<uParse :content="goods.goodsDesc" noData=" " />
				</view>

				<view class="common-problem">
					<view class="tui-nomore-box">
						<tui-nomore text="常见问题" backgroundColor="#fafafa"></tui-nomore>
					</view>
					<view class="b">
						<view class="item" v-for="(item, index) in issueList" :key="index">
							<view class="question-box">
								<text class="spot"></text>
								<text class="question">{{item.question}}</text>
							</view>
							<view class="answer">
								{{item.answer}}
							</view>
						</view>
					</view>
				</view>
			</view>
		</scroll-view>
		<!--底部选择层-->
		<tui-bottom-popup :show="openAttr" tui-popup-class="tui-popup" @close="switchAttrPop">
			<view class="tui-popup-box">
				<view class="tui-product-box tui-padding">
					<image :src="selectPic" @click="previewSkuImg(selectPic)" class="tui-popup-img"></image>
					<view class="tui-popup-price">
						<view class="tui-amount tui-bold">￥{{selectPrice}}<text
								class="tui-original-price tui-gray tui-line-through">￥{{selectMarketPrice||''}}</text>
						</view>
						<view class="tui-number">编号:{{goods.goodsSn}} 库存：{{selectStock}}</view>
					</view>
				</view>
				<scroll-view scroll-y class="tui-popup-scroll">
					<view class="tui-scrollview-box">
						<view class="tui-bold tui-attr-title" v-for="(attrValueObj, attrIndex) in keyValue"
							:key="attrIndex">{{attrValueObj.key}}
							<view class="tui-attr-box">
								<view v-for="(value, valueIndex) in attrValueObj.attrValues" :key="valueIndex"
									:class="'tui-attr-item tui-attr-item-' + (attrIndex==firstIndex || attrValueObj.attrValueStatus[valueIndex]?(value==attrValueObj.selectedValue?'active':''):'disabled')"
									@tap="selectAttrValue" :data-status="attrValueObj.attrValueStatus[valueIndex]"
									:data-value="value" :data-key="attrValueObj.key" :data-index="attrIndex"
									:data-selectedvalue="attrValueObj.selectedValue">{{value}}</view>
							</view>
						</view>
						<view class="tui-number-box tui-bold tui-attr-title">
							<view class="tui-attr-title">数量</view>
							<tui-numberbox :iconSize="22" :height="38" :width="56" :value="number" :step="1"
								:min="minNumber||1" @change="changeNumber"></tui-numberbox>
						</view>
					</view>
				</scroll-view>
				<view class="tui-operation tui-operation-right tui-right-flex tui-popup-btn">
					<tui-button type="danger" shape="circle" :size="25" class="tui-btn-equals tui-flex"
						@click="buyOrCartAdd">确定</tui-button>
				</view>
				<tui-icon name="close-fill" color="#999" class="tui-icon-close" :size="25" @click="switchAttrPop">
				</tui-icon>
			</view>
		</tui-bottom-popup>

		<tui-bottom-popup :show="shareVisible" class="tui-popup" @close="hideShare">
			<view class="share-bottom">
				<view class="share-bottom-footer">
					<view class="share-to">分享到</view>
					<view class="imgs">
						<!-- #ifdef MP-WEIXIN || MP-TOUTIAO -->
						<button class="btn-share" open-type="share">
							<image class='sharebtn_image' src='/static/images/mall/weixin.png'></image>
						</button>
						<button class="btn-share" @tap="pengyouquan">
							<image class='sharebtn_image' src='/static/images/mall/pengyouquan.png'></image>
						</button>
						<!-- #endif -->

						<!-- #ifdef APP-PLUS -->
						<button class="btn-share" @tap="shareApp">
							<image class='sharebtn_image' src='/static/images/mall/weixin.png'></image>
						</button>
						<!-- #endif -->
            <!-- #ifdef MP-WEIXIN || APP-PLUS -->
						<button class="btn-share" @tap="createPoster">
							<image class='sharebtn_image' src='/static/images/mall/haibao.png'></image>
						</button>
            <!-- #endif -->
					</view>
					<button class="btn-share" @tap="hideShare">取消</button>
				</view>
			</view>
		</tui-bottom-popup>

		<view class="bottom-btn">
			<view class="l l-cart">
				<view class="box" @tap="switchShops" data-name="cart">
					<image class="icon" src="/static/images/mall/shops.png"></image>
				</view>
			</view>
			<view :class="'l l-collect '+ (openAttr ? 'back' : '')" @tap="closeAttrOrCollect">
				<image class="icon" :src="collectBackImage"></image>
			</view>
			<view class="l l-cart">
				<view class="box" @tap="switchNav" data-name="cart">
					<text class="cart-count">{{cartGoodsCount}}</text>
          <image class="icon" src="/static/images/mall/cart.png"></image>
				</view>
			</view>
      <tui-button type="danger" tui-button-class="tui-btn-equals" shape="circle" :size="25" height="60rpx" class="tui-flex-border" @click="addToCart">加入购物车</tui-button>
      <tui-button type="warning" tui-button-class="tui-btn-equals" shape="circle" :size="25" height="60rpx" class="tui-flex-border" @click="buyGoods">立即购买</tui-button>
		</view>
		<!--生成海报  -->
		<!--底部分享弹层-->
		<canvas :style="{ width: winWidth + 'px', height: winHeight + 'px' }" canvas-id="posterId" id="posterId"
			class="tui-poster__canvas"></canvas>
		<tui-modal custom :show="modalShow" backgroundColor="transparent" padding="0" @cancel="hideModal">
			<view class="tui-poster__box" :style="{marginTop:height+'px'}">
				<image src="/static/images/mall/icon_popup_closed.png" class="tui-close__img" @tap.stop="hideModal">
				</image>
				<image :src="posterImg" v-if="posterImg" class="tui-poster__img"></image>
				<tui-button type="danger" width="460rpx" height="80rpx" shape="circle" @click="savePic">保存图片
				</tui-button>
				<view class="tui-share__tips">保存图片到手机相册后，将图片分享到您的圈子</view>
			</view>
		</tui-modal>
	</view>
</template>

<script>
	const app = getApp()
	const util = require("@/utils/util.js")
	import uParse from '@/components/uni/uParse/src/wxParse'
	const poster = require('@/components/common/tui-poster/tui-poster.js');
	export default {
		components: {
			uParse
		},
		data() {
			return {
				winWidth: uni.upx2px(560 * 2),
				winHeight: uni.upx2px(890 * 2),
				modalShow: false,
				posterImg: '',
				height: 64, //header高度
				top: 0, //标题图标距离顶部距离
				scrollH: 0, //滚动总高度
				opcity: 0,
				iconOpcity: 0.5,
				menuShow: false,
				id: '',
				firstIndex: 0,
				goods: {},
				gallery: [],
				attribute: [],
				issueList: [],
				comment: [],
				cartGoodsCount: 0,
				userHasCollect: 0,
				number: 1,
				minNumber: 1,
				checkedSpecText: '',
				openAttr: false,
				showNavList: false,
				collectBackImage: "/static/images/mall/icon_collect.png",
				commodityAttr: [],
				keyValue: [],
				selected: '',
				selectPrice: '',
				selectMarketPrice: '',
				selectPic: '',
				selectStock: '',
				selectedText: '',
				includeGroup: [],
				tempQrCode: '', // 商品小程序码
				tempGoodsListPic: '', // 商品图
				shareVisible: false,
				referrerUserId: '',
				buyType: '',
				historyList: [],
        historyTop: 130,
        couponList: [],
        bannerIndex: 0,
        shippingFeeFree: ''
			};
		},
		onShow: function(options) {
			this.getCartInfo()
		},
		onLoad: function(options) {
			let obj = {};
			// #ifdef MP-WEIXIN
			obj = uni.getMenuButtonBoundingClientRect();

			uni.showShareMenu({
				withShareTicket: true,
				menus: ['shareAppMessage', 'shareTimeline']
			})
			// #endif

			// #ifdef MP-BAIDU
			obj = swan.getMenuButtonBoundingClientRect();
			// #endif

			// #ifdef MP-ALIPAY
			my.hideAddToDesktopMenu();
      this.historyTop = 40
			// #endif

			let that = this;
			//转发的用户Id
			if (options.referrer) {
				app.globalData.referrerUserId = options.referrer;
				that.referrerUserId = options.referrer;
			}
      uni.setStorageSync("navUrl", "/pages/goods/goods?id=" + options.id + "&referrer=" + that.referrerUserId);
			// 页面初始化 options为页面跳转所带来的参数
			that.id = options.id;
			that.getGoodsInfo();
			that.goodsHistory();
      that.getCouponList();
      that.getShippingFeeFree();

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
			this.opcity = opcity;
			this.iconOpcity = 0.5 * (1 - opcity < 0 ? 0 : 1 - opcity);
		},
		methods: {
      bannerChange: function(e) {
        this.bannerIndex = e.detail.current;
      },
      play(url) {
        uni.navigateTo({
          url: '/pages/video/video?url=' + url,
          animationType: 'zoom-out'
        })
      },
      person: function() {
        uni.switchTab({
          url: '/pages/ucenter/index/index',
        })
      },
      coupon() {
        uni.navigateTo({
          url: '/pages/shopping/couponCenter/couponCenter'
        })
      },
      getShippingFeeFree() {
        let that = this;
        util.request('index/getConfigByKey', {
          key: 'SHIPPING_FEE_FREE'
        }).then(function(res) {
          if (res.code === 0) {
            that.shippingFeeFree = res.data
          }
        });
      },
      getCouponList() {
        let that = this;
        util.request('coupon/couponList').then(function(res) {
          if (res.code === 0) {
            that.couponList = res.data
          }
        });
      },
			showSharePopup() {
				this.sharePopup = true
			},
			hideSharePopup() {
				this.sharePopup = false
			},
			hideModal() {
				this.modalShow = false;
				this.shareVisible = false
			},
			savePic() {
				if (this.posterImg) {
					// #ifdef H5
					uni.previewImage({
						urls: [this.posterImg]
					});
					// #endif

					// #ifndef H5
					poster.saveImage(this.posterImg);
					// #endif

					this.hideModal();
				}
			},
			goodsHistory: function() {
				let that = this;
				util.request('goods/history', {
					goodsId: that.id
				}).then(function(res) {
					if (res.code === 0) {
						that.historyList = res.data.records;
					}
				});
			},
			changeNumber: function(event) {
				this.number = event.value;
			},
			toggleNav() {
				this.showNavList = !this.showNavList
			},
			shareApp() {
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
							imageUrl: that.goods.listPicUrl,
							title: that.goods.name,
							miniProgram: {
								id: util.maAppId,
								path: 'pages/goods/goods?id=' + that.goods.id + '&referrer=' + uni
									.getStorageSync('userId'),
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
			},
			pengyouquan() {
				util.toast('请点击右上角分享到朋友圈')
				this.shareVisible = false
			},
			async createPoster() {
				let that = this
				that.hideSharePopup()
				if (that.posterImg) {
					that.modalShow = true;
					return;
				}
				uni.showLoading({
					mask: true,
					title: '图片生成中...'
				});
				// #ifdef MP-WEIXIN
				await poster.removeSavedFile();
				// #endif

				//小程序码长宽
				let codeSize = 200;
				util.request('goods/getGoodsQrCode', {
					goodsId: that.goods.id,
					width: codeSize
				}).then(function(resp) {
					if (resp.code === 0) {
						uni.downloadFile({
							//url网络图片地址必须要在小程序中配备合法域名
							url: resp.url,
							success(res) {
								if (res.statusCode === 200) {
									that.tempQrCode = res.tempFilePath

									const imgs = {
										mainPic: that.tempGoodsListPic,
										qrcode: that.tempQrCode
									};
									poster.drawGoodsPoster('posterId', that.winWidth, that.winHeight,
										imgs, that.goods.name, that.goods.retailPrice, that.goods
										.marketPrice, that.goods
										.promotionDesc || '',
										res => {
											uni.hideLoading();
											if (res) {
												that.posterImg = res;
												setTimeout(() => {
													that.modalShow = true;
												}, 60);
											} else {
												util.toast('生成海报失败,请稍后再试');
											}
										});
								}
							}
						})
					}
				});
			},
			back: function() {
				uni.navigateBack({
					fail() {
						uni.switchTab({
							url: '/pages/index/index',
						})
					}
				})
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
			},
			commonDetail: function(goodsId) {
				uni.navigateTo({
					url: '../comment/comment?goodsId=' + goodsId + '&type=0'
				})
			},
			feedback: function() {
				uni.navigateTo({
					url: '/pages/feedback/feedback',
				})
			},
			openMenu: function() {
				this.menuShow = true
			},
			closeMenu: function() {
				this.menuShow = false
			},
			showShare: function() {
        // #ifdef MP-ALIPAY
        uni.showShareMenu()
        // #endif
        // #ifndef MP-ALIPAY
				this.menuShow = false
				this.shareVisible = true
        // #endif
			},
			hideShare: function() {
				this.shareVisible = false
			},
			switchNav(event) {
				let name = event.currentTarget.dataset.name;
				// #ifdef MP-TOUTIAO
				// 头条switchTab不能跳转
				uni.reLaunch({
					url: `/pages/${name}/${name}`
				});
				// #endif
				// #ifndef MP-TOUTIAO
				uni.switchTab({
					url: `/pages/${name}/${name}`
				});
				// #endif
			},
			switchShops() {
				uni.navigateTo({
					url: `/pages/shops/shops?shopsSn=${this.goods.shopsSn}`
				})
			},
			getCartInfo: function() {
				let that = this;
				if (this.goods.shopsId) {
					util.request('cart/myCart', {
						shopsId: that.goods.shopsId
					}).then(function(resp) {
						if (resp.code === 0) {
							that.cartGoodsCount = resp.cartTotal.goodsCount;
						}
					});
				} else {
					util.request('cart/goodsCount', {
						userId: uni.getStorageSync('userId') || ''
					}).then(function(resp) {
						if (resp.code === 0) {
							that.cartGoodsCount = resp.goodsCount;
						}
					});
				}
			},
			getGoodsInfo: function() {
				let that = this;
				util.request('goods/otherDetail', {
					goodsId: that.id,
					userId: uni.getStorageSync('userId') || ''
				}).then(function(res) {
					if (res.code === 0) {
						that.issueList = res.data.issue;
						that.comment = res.data.comment;
						that.userHasCollect = res.data.userHasCollect;
						if (res.data.userHasCollect == 1) {
							that.collectBackImage = "/static/images/mall/icon_collect_checked.png"
						} else {
							that.collectBackImage = "/static/images/mall/icon_collect.png"
						}
					}
				});
				util.request('goods/detail', {
					goodsId: that.id,
					userId: uni.getStorageSync('userId') || ''
				}).then(function(res) {
					if (res.code === 0) {
						that.goods = res.data.info
						that.minNumber = that.goods.minSell || 1
						that.number = that.minNumber
						that.gallery = res.data.info.attachmentEntityList
						that.attribute = res.data.info.goodsAttributeEntityList
						that.selectPrice = res.data.info.retailPrice
						that.selectMarketPrice = res.data.info.marketPrice
						that.selectPic = res.data.info.listPicUrl
						that.selectStock = res.data.info.goodsNumber

						uni.downloadFile({
							//url网络图片地址必须要在小程序中配备合法域名
							url: that.goods.listPicUrl,
							success(respose) {
								if (respose.statusCode === 200) {
									that.tempGoodsListPic = respose.tempFilePath;
								}
							}
						})
						that.commodityAttr = res.data.info.goodsSkuEntityList;
						that.includeGroup = that.commodityAttr;
						that.distachAttrValue(that.commodityAttr);
						that.getCartInfo();
					}
				});
			},
			previewSkuImg(url) {
				uni.previewImage({
					urls: [url], // 需要预览的图片http链接列表
				})
			},
			//放大预览轮播图片
			previewImg: function(e) {
				var curImg = e.currentTarget.dataset.img;
				var gallery = this.gallery;
				if (!util.isEmpty(curImg) && gallery.length > 0) {
					var urls = [];
					for (var i = 0; i < gallery.length; i++) {
						urls[i] = gallery[i].url;
					}
					uni.previewImage({
						current: curImg, // 当前显示图片的http链接
						urls: urls, // 需要预览的图片http链接列表
					})
				}
			},
			switchAttrPop: function() {
				this.buyType = 'select'
				this.openAttr = !this.openAttr;
			},
			closeAttrOrCollect: function() {
				let that = this;
				//添加或是取消收藏
				util.request('user/addOrDelete', {
					goodsId: that.id
				}, "POST").then(function(res) {
					if (res.code == 0) {
						if (res.data.type == 'add') {
							util.toast('收藏成功');
							that.collectBackImage = "/static/images/mall/icon_collect_checked.png";
						} else {
							util.toast('取消成功');
							that.collectBackImage = "/static/images/mall/icon_collect.png"
						}
					}
				});
			},
			buyOrCartAdd: function() {
				var that = this;
				var value = [];
				for (var i = 0; i < that.keyValue.length; i++) {
					if (!that.keyValue[i].selectedValue) {
						break;
					}
					value.push(that.keyValue[i].selectedValue);
				}
				if (i < that.keyValue.length) {
					util.toast('请选择完整！');
				} else {
					if (!that.includeGroup[0]) {
						util.toast('商家暂未添加商品规格！');
						return;
					}
					if (that.buyType == 'select') {
						that.openAttr = !that.openAttr;
					}
					if (that.buyType == 'buy') {
						// 直接购买商品
						util.request('buy/add', {
							skuId: that.includeGroup[0].id,
							goodsId: that.goods.id,
							number: that.number,
							selectedText: that.selectedText,
							shopsId: that.goods.shopsId
						}, "POST", 'application/json').then(function(res) {
							let _res = res;
							if (_res.code == 0) {
								that.openAttr = !that.openAttr;
								let promoUserId = '&promoUserId=';
								if (that.referrerUserId !== '') {
									promoUserId = promoUserId + that.referrerUserId;
								}
								uni.navigateTo({
									url: '/pages/shopping/checkout/checkout?isBuy=true' +
										promoUserId + '&shopsId=' + that.goods.shopsId,
								})
							}
						});
					}
					if (that.buyType == 'cart') {
						//添加到购物车
						util.request('cart/add', {
							skuId: that.includeGroup[0].id,
							goodsId: that.goods.id,
							referrerUserId: that.referrerUserId,
							number: that.number,
							selectedText: that.selectedText,
							shopsId: that.goods.shopsId
						}, "POST").then(function(res) {
							let _res = res;
							if (_res.code == 0) {
								util.toast('添加成功');
								that.openAttr = !that.openAttr;
								that.cartGoodsCount = _res.cartTotal.goodsCount;
							}
						});
					}
				}
			},
			/**
			 * 直接购买
			 */
			buyGoods: function() {
				var that = this;
				that.buyType = 'buy'
				if (that.openAttr == false) {
					//打开规格选择窗口
					this.openAttr = !this.openAttr;
				}
			},
			addToCart: function() {
				var that = this;
				that.buyType = 'cart'
				if (that.openAttr == false) {
					//打开规格选择窗口
					that.openAttr = !that.openAttr;
				}
			},
			/* 获取数据 */
			distachAttrValue: function(commodityAttr) {
				/**
				将后台返回的数据组合成类似
				{
				key:'型号',
				keyValue:['1','2','3']
				}
				*/
				// 把数据对象的数据（视图使用），写到局部内
				var keyValue = this.keyValue;
				// 遍历获取的数据
				for (var i = 0; i < commodityAttr.length; i++) {
					for (var j = 0; j < commodityAttr[i].keyValue.length; j++) {
						var attrIndex = this.getAttrIndex(commodityAttr[i].keyValue[j].key, keyValue);
						// console.log('属性索引', attrIndex);
						// 如果还没有属性索引为-1，此时新增属性并设置属性值数组的第一个值；索引大于等于0，表示已存在的属性名的位置
						if (attrIndex >= 0) {
							// 如果属性值数组中没有该值，push新值；否则不处理
							if (!this.isValueExist(commodityAttr[i].keyValue[j].value, keyValue[attrIndex]
									.attrValues)) {
								keyValue[attrIndex].attrValues.push(commodityAttr[i].keyValue[j].value);
							}
						} else {
							keyValue.push({
								key: commodityAttr[i].keyValue[j].key,
								attrValues: [commodityAttr[i].keyValue[j].value]
							});
						}
					}
				}
				for (var i = 0; i < keyValue.length; i++) {
					for (var j = 0; j < keyValue[i].attrValues.length; j++) {
						if (keyValue[i].attrValueStatus) {
							keyValue[i].attrValueStatus[j] = true;
						} else {
							keyValue[i].attrValueStatus = [];
							keyValue[i].attrValueStatus[j] = true;
						}
					}
				}
				this.keyValue = keyValue;
			},
			getAttrIndex: function(attrName, keyValue) {
				// 判断数组中的attrKey是否有该属性值
				for (var i = 0; i < keyValue.length; i++) {
					if (attrName == keyValue[i].key) {
						break;
					}
				}
				return i < keyValue.length ? i : -1;
			},
			isValueExist: function(value, valueArr) {
				// 判断是否已有属性值
				for (var i = 0; i < valueArr.length; i++) {
					if (valueArr[i] == value) {
						break;
					}
				}
				return i < valueArr.length;
			},
			/* 选择属性值事件 */
			selectAttrValue: function(e) {
				/*
				点选属性值，联动判断其他属性值是否可选
				{
				key:'型号',
				keyValue:['1','2','3'],
				selectedValue:'1',
				attrValueStatus:[true,true,true]
				}
				console.log(e.currentTarget.dataset);
				*/
				var keyValue = this.keyValue;
				var index = e.currentTarget.dataset.index; //属性索引
				var key = e.currentTarget.dataset.key;
				var value = e.currentTarget.dataset.value;
				if (e.currentTarget.dataset.status || index == this.firstIndex) {
					if (e.currentTarget.dataset.selectedvalue == e.currentTarget.dataset.value) {
						// 取消选中
						this.disSelectValue(keyValue, index, key, value);
					} else {
						// 选中
						this.selectValue(keyValue, index, key, value);
					}
				}
			},
			/* 选中 */
			selectValue: function(keyValue, index, key, value) {
				var includeGroup = [];
				if (index == this.firstIndex) { // 如果是第一个选中的属性值，则该属性所有值可选
					var commodityAttr = this.commodityAttr;
					// 其他选中的属性值全都置空
					// console.log('其他选中的属性值全都置空', index, this.firstIndex);
					for (var i = 0; i < keyValue.length; i++) {
						for (var j = 0; j < keyValue[i].attrValues.length; j++) {
							keyValue[i].selectedValue = '';
						}
					}
				} else {
					var commodityAttr = this.includeGroup;
				}
				for (var i = 0; i < commodityAttr.length; i++) {
					for (var j = 0; j < commodityAttr[i].keyValue.length; j++) {
						if (commodityAttr[i].keyValue[j].key == key && commodityAttr[i].keyValue[j].value == value) {
							includeGroup.push(commodityAttr[i]);
						}
					}
				}
				keyValue[index].selectedValue = value;

				// 判断属性是否可选
				for (var i = 0; i < keyValue.length; i++) {
					for (var j = 0; j < keyValue[i].attrValues.length; j++) {
						keyValue[i].attrValueStatus[j] = false;
					}
				}
				for (var k = 0; k < keyValue.length; k++) {
					for (var i = 0; i < includeGroup.length; i++) {
						for (var j = 0; j < includeGroup[i].keyValue.length; j++) {
							if (keyValue[k].key == includeGroup[i].keyValue[j].key) {
								for (var m = 0; m < keyValue[k].attrValues.length; m++) {
									if (keyValue[k].attrValues[m] == includeGroup[i].keyValue[j].value) {
										keyValue[k].attrValueStatus[m] = true;
									}
								}
							}
						}
					}
				}
				this.keyValue = keyValue;
				this.includeGroup = includeGroup;

				var count = 0;
				for (var i = 0; i < keyValue.length; i++) {
					for (var j = 0; j < keyValue[i].attrValues.length; j++) {
						if (keyValue[i].selectedValue) {
							count++;
							break;
						}
					}
				}
				if (count < 2) { // 第一次选中，同属性的值都可选
					this.firstIndex = index
				} else {
					this.firstIndex = -1
				}
				this.setSelect();
			},
			/* 取消选中 */
			disSelectValue: function(keyValue, index, key, value) {
				var that = this;
				var commodityAttr = that.commodityAttr;
				keyValue[index].selectedValue = '';

				// 判断属性是否可选
				for (var i = 0; i < keyValue.length; i++) {
					for (var j = 0; j < keyValue[i].attrValues.length; j++) {
						keyValue[i].attrValueStatus[j] = true;
					}
				}
				this.keyValue = keyValue;
				this.includeGroup = commodityAttr;

				for (var i = 0; i < keyValue.length; i++) {
					if (keyValue[i].selectedValue) {
						that.selectValue(keyValue, i, keyValue[i].key, keyValue[i].selectedValue, true);
					}
				}
				that.setSelect();
			},
			setSelect: function() {
				var that = this;
				var valueStr = "";
				var value = [];
				var selectedText = '';
				for (var i = 0; i < that.keyValue.length; i++) {
					if (!that.keyValue[i].selectedValue) {
						break;
					}
					value.push(that.keyValue[i].selectedValue);
					selectedText += that.keyValue[i].key + '：' + that.keyValue[i].selectedValue + '；'
				}
				for (var i = 0; i < value.length; i++) {
					valueStr += value[i] + ",";
				}
				valueStr = valueStr.substr(0, valueStr.length - 1)
				that.selected = valueStr

				if (!that.includeGroup[0] || !valueStr) {
					that.selectPic = that.goods.listPicUrl
					that.selectMarketPrice = that.goods.marketPrice
					that.selectPrice = that.goods.retailPrice
					that.selectStock = that.goods.goodsNumber
					that.selectedText = selectedText
					return;
				}
				that.selectPic = that.includeGroup[0].listPicUrl || that.goods.listPicUrl
				that.selectMarketPrice = that.includeGroup[0].marketPrice
				that.selectPrice = that.includeGroup[0].retailPrice
				that.selectStock = that.includeGroup[0].goodsNumber
				that.selectedText = selectedText
				that.minNumber = that.includeGroup[0].minSell || 1
				that.number = that.minNumber
			}
		},
		onShareTimeline() {
			var that = this;
			let shareDesc = that.goods.name;
			let goods = that.goods;
			shareDesc += ' ' + goods.retailPrice + "元";
			// 设置菜单中的转发按钮触发转发事件时的转发内容
			var shareObj = {
				title: shareDesc, // 默认是小程序的名称(可以写slogan等)
				path: '/pages/goods/goods?id=' + that.id + '&&referrer=' + uni.getStorageSync(
					'userId'), // 默认是当前页面，必须是以‘/’开头的完整路径
				//query: 'id=' + that.data.id + '&referrer=' +uni.getStorageSync('userId'),
				imageUrl: that.goods
					.listPicUrl, //自定义图片路径，可以是本地文件路径、代码包文件路径或者网络图片路径，支持PNG及JPG，不传入 imageUrl 则使用默认截图。显示图片长宽比是 5:4
				success: function(res) {
					// 转发成功之后的回调
					if (res.errMsg == 'shareAppMessage:ok') {
						util.toast('转发成功');
					}
				},
				fail: function() {
					// 转发失败之后的回调
					if (res.errMsg == 'shareAppMessage:fail cancel') {
						// 用户取消转发
					} else if (res.errMsg == 'shareAppMessage:fail') {
						// 转发失败，其中 detail message 为详细失败信息
					}
				},
				complete: function() {
					// 转发结束之后的回调（转发成不成功都会执行）
				}
			};
			return shareObj;
		},
		onShareAppMessage() {
			var that = this;

			let shareDesc = that.goods.name;
			let goods = that.goods;
			shareDesc += ' ' + goods.retailPrice + "元";
			// 设置菜单中的转发按钮触发转发事件时的转发内容
			var shareObj = {
				title: shareDesc, // 默认是小程序的名称(可以写slogan等)
        desc: that.goods.promotionDesc,
				path: '/pages/goods/goods?id=' + that.id + '&&referrer=' + uni.getStorageSync(
					'userId'), // 默认是当前页面，必须是以‘/’开头的完整路径
				imageUrl: that.goods
					.listPicUrl, //自定义图片路径，可以是本地文件路径、代码包文件路径或者网络图片路径，支持PNG及JPG，不传入 imageUrl 则使用默认截图。显示图片长宽比是 5:4
				success: function(res) {
					// 转发成功之后的回调
					if (res.errMsg == 'shareAppMessage:ok') {
						util.toast('转发成功');
					}
				},
				fail: function(res) {
					// 转发失败之后的回调
					if (res.errMsg == 'shareAppMessage:fail cancel') {
						// 用户取消转发
					} else if (res.errMsg == 'shareAppMessage:fail') {
						// 转发失败，其中 detail message 为详细失败信息
					}
				},
				complete: function() {
					// 转发结束之后的回调（转发成不成功都会执行）
				}
			};
			return shareObj;
		}
	};
</script>

<style>
	.container {
		margin-bottom: 50rpx;
	}

  .tui-banner-swiper {
    position: relative;
  }

  .tui-video__box {
    width: 166rpx;
    height: 60rpx;
    position: absolute;
    left: 50%;
    bottom: 50rpx;
    transform: translateX(-50%);
    z-index: 2;
  }

  .tui-video__box image {
    width: 166rpx;
    height: 60rpx;
  }

  .tui-video__box view {
    width: 100%;
    height: 100%;
    font-size: 24rpx;
    position: absolute;
    left: 0;
    top: 0;
    display: flex;
    align-items: center;
    padding-left: 66rpx;
    box-sizing: border-box;
  }

  .tui-banner-tag {
    position: absolute;
    color: #fff;
    bottom: 30rpx;
    right: 0;
  }

	.goodsimgs {
		width: 750rpx;
		height: 750rpx;
	}

	.goodsimgs .list {
		width: 750rpx;
		height: 750rpx;
	}

	.tui-padding {
		padding: 0 30rpx;
		box-sizing: border-box;
	}

	.tui-ml-auto {
		margin-left: auto;
	}

	/* #ifdef H5 */
	.tui-ptop {
		padding-top: 44px;
	}

	/* #endif */

	.tui-size {
		font-size: 24rpx;
		line-height: 24rpx;
	}

	.tui-gray {
		color: #999;
	}

	.tui-icon-red {
		color: #ff201f;
	}

	.tui-border-radius {
		border-bottom-left-radius: 24rpx;
		border-bottom-right-radius: 24rpx;
		overflow: hidden;
	}

	.tui-radius-all {
		border-radius: 24rpx;
		overflow: hidden;
	}

	.tui-mtop {
		margin-top: 26rpx;
	}

	.tui-pro-detail {
		box-sizing: border-box;
		color: #333;
	}

	.tui-product-title {
		background: #fff;
		padding: 30rpx 0;
	}

	.tui-pro-pricebox {
		display: flex;
		align-items: center;
		justify-content: space-between;
		color: #ff201f;
		font-size: 36rpx;
		font-weight: bold;
		line-height: 44rpx;
	}

	.tui-pro-price {
		display: flex;
		align-items: center;
	}

	.tui-price {
		font-size: 58rpx;
	}

	.tui-original-price {
		font-size: 26rpx;
		line-height: 26rpx;
		padding: 10rpx 30rpx;
		box-sizing: border-box;
	}

	.tui-line-through {
		text-decoration: line-through;
	}

	.tui-collection {
		color: #333;
		display: flex;
		align-items: center;
		flex-direction: column;
		justify-content: center;
		height: 44rpx;
	}

	.tui-scale-collection {
		transform: scale(0.7);
		transform-origin: center 90%;
		line-height: 24rpx;
		font-weight: normal;
		margin-top: 4rpx;
	}

	.tui-pro-titbox {
		font-size: 32rpx;
		font-weight: 500;
		position: relative;
		padding: 0 150rpx 0 30rpx;
		box-sizing: border-box;
	}

	.tui-pro-title {
		padding-top: 20rpx;
	}

	.tui-share-btn {
		display: block;
		background: transparent;
		margin: 0;
		padding: 0;
		border-radius: 0;
		border: 0;
	}

	.tui-share-btn::after {
		border: 0;
	}

	.tui-share-box {
		display: flex;
		align-items: center;
	}

	.tui-share-position {
		position: absolute;
		right: 0;
		top: 30rpx;
	}

	.tui-share-text {
		padding-left: 8rpx;
	}

	.tui-sub-title {
		padding: 20rpx 0;
		line-height: 32rpx;
	}

	.tui-sale-info {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding-top: 30rpx;
	}

	.tui-discount-box {
		background: #fff;
	}

	.tui-list-cell {
		width: 100%;
		position: relative;
		display: flex;
		align-items: center;
		font-size: 26rpx;
		line-height: 26rpx;
		padding: 36rpx 30rpx;
		box-sizing: border-box;
	}

	.tui-right {
		position: absolute;
		right: 30rpx;
		top: 30rpx;
	}

	.tui-top40 {
		top: 40rpx !important;
	}

	.tui-bold {
		font-weight: bold;
	}

	.tui-list-cell::after {
		content: '';
		position: absolute;
		border-bottom: 1rpx solid #eaeef1;
		-webkit-transform: scaleY(0.5);
		transform: scaleY(0.5);
		bottom: 0;
		right: 0;
		left: 126rpx;
	}

	.tui-last::after {
		border-bottom: 0 !important;
	}

	.tui-flex-center {
		display: flex;
		align-items: center;
	}

	.tui-cell-title {
		padding-right: 30rpx;
		flex-shrink: 0;
	}

	.tui-promotion-box {
		display: flex;
		align-items: center;
		padding: 10rpx 0;
		width: 80%;
	}

	.tui-promotion-box text {
		width: 70%;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.tui-basic-info {
		background: #fff;
	}

	.tui-addr-box {
		width: 76%;
	}

	.tui-addr-item {
		padding: 10rpx;
		line-height: 34rpx;
	}

	.tui-guarantee {
		background: #fdfdfd;
		display: flex;
		flex-wrap: wrap;
		padding: 20rpx 30rpx 30rpx 30rpx;
		font-size: 24rpx;
	}

	.tui-guarantee-item {
		color: #999;
		padding-right: 30rpx;
		padding-top: 10rpx;
	}

	.tui-pl {
		padding-left: 4rpx;
	}

	.tui-cmt-box {
		background: #fff;
	}

	.tui-between {
		justify-content: space-between !important;
	}

	.tui-cmt-all {
		color: #ff201f;
		padding-right: 8rpx;
	}

	.tui-cmt-content {
		font-size: 26rpx;
	}

	.tui-cmt-content .img {
		width: 120rpx;
		height: 120rpx;
		padding: 0 10rpx;
	}

	.tui-cmt-user {
		display: flex;
		align-items: center;
	}

	.tui-acatar {
		width: 60rpx;
		height: 60rpx;
		border-radius: 30rpx;
		display: block;
		margin-right: 16rpx;
	}

	.tui-cmt {
		padding: 14rpx 0;
	}

	.tui-attr {
		font-size: 24rpx;
		color: #999;
		padding: 6rpx 0;
	}

	.tui-cmt-btn {
		padding: 50rpx 0 30rpx 0;
		box-sizing: border-box;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.tui-nomore-box {
		padding-top: 10rpx;
	}

	.bottom-btn .c {
		float: left;
		height: 100rpx;
		line-height: 96rpx;
		flex: 1;
		text-align: center;
		color: #333;
		border-top: 1px solid #f4f4f4;
		border-bottom: 1px solid #f4f4f4;
	}


	.brand text {
		min-height: 40rpx;
		text-align: center;
		display: inline-block;
		width: auto;
		padding: 2px 30rpx 2px 10.5rpx;
		line-height: 35.5rpx;
		border: 1px solid #f48f18;
		font-size: 25rpx;
		color: #f48f18;
		border-radius: 4px;
		background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAASCAMAAABVab95AAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAABFUExURUdwTPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPSPGPYJSdIAAAAWdFJOUwAWD/DBJz/LB/iy5Omi0N0eMpVL01IOd4F9AAAAVUlEQVQI113OUQ6AIAwDUIbIRBBUtPc/qiZuzriv97G0dXysTo7RRiExstoHlE08BQxRPX+8IHXNuX2qdxRjtoeuESn+wqzOM8ozguo7p6Lp4MAkugBtDwOjtuSdGAAAAABJRU5ErkJggg==) 95% center no-repeat;
		background-size: 10.75rpx 18.75rpx;
	}


	.goods-attr {
		width: 750rpx;
		overflow: hidden;
		padding: 0 31.25rpx 25rpx 31.25rpx;
		background: #fff;
	}

	.goods-attr .t {
		width: 687.5rpx;
		height: 104rpx;
		line-height: 104rpx;
		font-size: 38.5rpx;
	}

	.goods-attr .item {
		padding: 5rpx 10rpx;
		margin-bottom: 5rpx;
		background: #f7f7f7;
		font-size: 38.5rpx;
		overflow: hidden;
	}

	.goods-attr .left {
		float: left;
		font-size: 25rpx;
		width: 110rpx;
		height: 45rpx;
		line-height: 45rpx;
		overflow: hidden;
		color: #999;
	}

	.goods-attr .right {
		float: left;
		font-size: 28rpx;
		margin-left: 20rpx;
		height: 45rpx;
		line-height: 45rpx;
		color: #333;
	}

	.detail {
		width: 750rpx;
		height: auto;
		overflow: hidden;
		background-color: #fff;
	}

	.detail .wxParse-p {
		margin: -1rpx 0;
	}

	.detail image {
		width: 750rpx;
		display: block;
	}

	.common-problem {
		width: 750rpx;
		height: auto;
		overflow: hidden;
	}

	.common-problem .h {
		position: relative;
		height: 145.5rpx;
		width: 750rpx;
		padding: 56.25rpx 0;
		background: #fff;
		text-align: center;
	}

	.common-problem .b {
		width: 750rpx;
		height: auto;
		overflow: hidden;
		padding: 0rpx 30rpx;
		background: #fff;
	}

	.common-problem .item {
		height: auto;
		overflow: hidden;
		padding-bottom: 25rpx;
	}

	.common-problem .question-box .spot {
		float: left;
		display: block;
		height: 8rpx;
		width: 8rpx;
		background: #b4282d;
		border-radius: 50%;
		margin-top: 11rpx;
	}

	.common-problem .question-box .question {
		display: block;
		font-size: 26rpx;
		padding-bottom: 15rpx;
		color: #303030;
	}

	.common-problem .answer {
		line-height: 36rpx;
		padding-left: 16rpx;
		font-size: 26rpx;
		color: #787878;
	}

	.related-goods {
		width: 750rpx;
		height: auto;
		overflow: hidden;
	}

	.related-goods .h {
		position: relative;
		height: 145.5rpx;
		width: 750rpx;
		padding: 56.25rpx 0;
		background: #fff;
		text-align: center;
		border-bottom: 1px solid #f4f4f4;
	}

	.related-goods .h .line {
		display: inline-block;
		position: absolute;
		top: 72rpx;
		left: 0;
		z-index: 2;
		height: 1px;
		margin-left: 125rpx;
		width: 500rpx;
		background: #e41f19;
	}

	.related-goods .h .title {
		display: inline-block;
		position: absolute;
		top: 56.125rpx;
		left: 0;
		z-index: 3;
		height: 33rpx;
		margin-left: 285rpx;
		width: 180rpx;
		background: #fff;
	}

	.related-goods .b {
		width: 750rpx;
		height: auto;
		overflow: hidden;
	}

	.related-goods .b .item {
		float: left;
		background: #fff;
		width: 375rpx;
		height: auto;
		overflow: hidden;
		text-align: center;
		border: 5px solid #f4f4f4;
	}

	.related-goods .item .img {
		width: 311.45rpx;
		height: 311.45rpx;
	}

	.related-goods .item .name {
		display: block;
		width: 311.45rpx;
		margin: 11.5rpx 0 15rpx 0;
		text-align: center;
		font-size: 25rpx;
		color: #333;
	}

	.related-goods .item .price {
		width: 311.45rpx;
		text-align: center;
		font-size: 30rpx;
		color: #e41f19;
	}

	.related-goods .item .price .cart {
		margin-left: 20rpx;
		width: 35rpx;
		height: 35rpx;
		vertical-align: -6rpx;
	}

	.bottom-btn {
		position: fixed;
		left: 0;
		bottom: 0;
		z-index: 99;
		width: 750rpx;
		height: 100rpx;
		display: flex;
		background: #fff;
	}

	.bottom-btn .l {
		float: left;
		height: 100rpx;
		width: 122rpx;
		border: 1px solid #f4f4f4;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.bottom-btn .l.l-collect {
		border: 1px solid #f4f4f4;
		text-align: center;
	}

	.bottom-btn .l.l-cart .box {
		position: relative;
		height: 60rpx;
		width: 60rpx;
	}

	.bottom-btn .l.l-cart .cart-count {
		height: 28rpx;
		width: 28rpx;
		z-index: 10;
		position: absolute;
		top: 0;
		right: 0;
		background: #e41f19;
		text-align: center;
		font-size: 18rpx;
		color: #fff;
		line-height: 28rpx;
		border-radius: 50%;
	}

	.bottom-btn .l.l-cart .icon {
		position: absolute;
		top: 10rpx;
		left: 0;
	}

	.bottom-btn .l .icon {
		display: block;
		height: 44rpx;
		width: 44rpx;
	}

	.bottom-btn .c {
		float: left;
		height: 100rpx;
		line-height: 96rpx;
		flex: 1;
		text-align: center;
		color: #333;
		border-top: 1px solid #f4f4f4;
		border-bottom: 1px solid #f4f4f4;
	}

	.bottom-btn .contact {
		float: left;
		height: 100rpx;
		width: 150rpx;
		border: 1px solid #f4f4f4;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.bottom-btn .r {
		border: 1px solid #e41f19;
		background: #e41f19;
		float: left;
		height: 100rpx;
		line-height: 96rpx;
		flex: 1;
		text-align: center;
		color: #fff;
	}

	.icon.chat {
		background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABTElEQVRYhe2WYZGDMBCFKyESKgEJSEACEiIBB0hAAhKQEAmVEAnf/Ug6cOmSLGnpzc3wZvjDhn2P3bdJbrcLFxQADNAAfXzab5GOgAM8Mh5AfwZ5G5Nr4YHuU+T2AHEK+y55l5TbA0vmryfhfV9Lfue1132MGYGoy8TuNQKGAkkqrsnEhhoBThDgCJ6YM7Hnd892jdR4gWOu32IhTI3l99g6gkd01RDKWIIntM0qxHtK5kRuQQ4DcmtyWHICJBPuJhLWays47gmQxmkPltf9oiWcF1tMMW9aKXnXJGxEJXjk3bIRBNiYNxUgV0HZikVIuBWX4iGtKxkyV4mJ44b9qICZMO/vwJUEzKy9NoRzomO9kGi8ksOgqYDJxA31bXC53GrEqvwN+UZEg/4McdQc00ohmlvUfAp5ImRr1pb1zmApjd4XxJnTWnDhX+MH8Paef0IieIEAAAAASUVORK5CYII=) !important;
		box-sizing: border-box;
		width: 60rpx;
		height: 60rpx;
		border: none;
		border-radius: 50%;
		margin-top: 15rpx;
		background-size: 100% 100%;
	}

	.modal-wrap {
		position: fixed;
		width: 100%;
		height: 100%;
		z-index: 900;
		top: 0;
		left: 0;
		background-color: rgba(0, 0, 0, 0.5);
	}

	/* 快捷导航 */
	.fast-nav {
		position: fixed;
		right: 20rpx;
		bottom: 200rpx;
		z-index: 995;
		display: flex;
		flex-direction: column;
		align-items: flex-end;
	}

	.fast-nav .nav {
		width: 80rpx;
		height: 80rpx;
		border-radius: 50%;
		background-color: #424242;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		margin-top: 20rpx;
		opacity: 0.6;
	}

	.fast-nav .nav text {
		color: #fff;
		font-size: 20rpx;
	}

	.fast-nav .contact {
		width: 80rpx;
		height: 80rpx;
		border-radius: 50%;
		background-color: #19c322;
		display: flex;
		flex-direction: column;
		align-items: center;
		opacity: 0.9;
		border: 0;
	}

	.fast-nav .nav-list .nav-item {
		height: 80rpx;
		width: 200rpx;
		margin-bottom: 20rpx;
		display: flex;
		justify-content: flex-end;
		align-items: center;
	}

	.fast-nav .nav-list .nav-item .nav-text {
		line-height: 80rpx;
		text-align: center;
		padding-right: 20rpx;
		color: #fff;
	}

	.fast-nav .nav-list .nav-item .nav-cell {
		height: 80rpx;
		width: 80rpx;
		display: flex;
		justify-content: center;
		align-items: center;
		background-color: #fff;
		border-radius: 50%;
	}

	.fast-nav .nav-list .nav-item .nav-cell image {
		height: 40rpx;
		width: 40rpx;
	}

	.fast-nav .close {
		width: 80rpx;
		height: 80rpx;
		border-radius: 50%;
		color: #fff;
		background-color: cornflowerblue;
		font-size: 50rpx;
		text-align: center;
		line-height: 80rpx;
	}

	.line-through {
		display: inline;
		color: rgb(153, 153, 153);
		font-size: 23rpx;
		text-decoration: line-through;
	}

	.attr-win {
		width: 100%;
		height: 100%;
		background-color: rgba(0, 0, 0, 0.2);
		position: fixed;
		bottom: 100rpx;
		z-index: 500;
		overflow: hidden;
	}

	.attr-pop {
		width: 100%;
		height: auto;
		padding: 31.25rpx;
		background: #fff;
		position: absolute;
		bottom: -233px;
	}

	.attr-close {
		float: right;
		width: 60rpx;
		height: 60rpx;
	}

	.attr-pop .img-info {
		width: 687.5rpx;
		height: 177rpx;
		overflow: hidden;
		margin-bottom: 41.5rpx;
	}

	.attr-pop .img-info .img {
		float: left;
		height: 177rpx;
		width: 177rpx;
		background: #f4f4f4;
		margin-right: 31.25rpx;
	}

	.attr-pop .img-info .info {
		display: flex;
		flex-wrap: nowrap;
		flex-direction: column;
		justify-content: center;
		overflow: hidden;
		height: 264rpx;
		width: 456rpx;
	}

	.img-info .info .pr {
		width: 456rpx;
		display: block;
		color: #e41f19;
		line-height: 50rpx;
		font-size: 33rpx;
	}

	.img-info .info .stock {
		width: 456rpx;
		display: block;
		color: #999;
		line-height: 50rpx;
		font-size: 20rpx;
	}

	.attr-pop .a {
		font-size: 29rpx;
		color: #333;
		height: 40rpx;
		line-height: 40rpx;
		width: 260px;
		display: block;
		word-break: break-all;
		word-wrap: break-word;
	}

	.spec-con {
		width: 100%;
		height: auto;
		overflow: hidden;
	}

	.spec-con .name {
		height: 50rpx;
		margin-bottom: 22rpx;
		font-size: 29rpx;
		color: #333;
	}

	.spec-con .values {
		height: auto;
		margin-bottom: 31.25rpx;
		font-size: 0;
	}

	.spec-con .value {
		display: inline-block;
		height: 62rpx;
		padding: 0 35rpx;
		line-height: 56rpx;
		text-align: center;
		margin-right: 25rpx;
		margin-bottom: 16.5rpx;
		border: 1px solid #333;
		font-size: 25rpx;
		color: #333;
	}


	.spec-con .value.selected {
		border: 1px solid #b4282d;
		color: #b4282d;
	}

	.number-item .selnum {
		width: 222rpx;
		height: 65rpx;
		border: 1px solid #ccc;
		display: flex;
		border-radius: 10px;
	}

	.number-item .cut {
		width: 53.75rpx;
		height: 100%;
		text-align: center;
		line-height: 60rpx;
	}

	.number-item .number {
		flex: 1;
		height: 100%;
		text-align: center;
		line-height: 60rpx;
		border-left: 1px solid #ccc;
		border-right: 1px solid #ccc;
		float: left;
	}

	.number-item .add {
		width: 53.75rpx;
		height: 100%;
		text-align: center;
		line-height: 60rpx;
	}

	.crash-goods {
		width: 750rpx;
		height: auto;
		overflow: hidden;
	}

	.crash-goods .h {
		position: relative;
		height: 145.5rpx;
		width: 750rpx;
		padding: 56.25rpx 0;
		background: #fff;
		text-align: center;
		border-bottom: 1px solid #f4f4f4;
	}

	.crash-goods .h .line {
		display: inline-block;
		position: absolute;
		top: 72rpx;
		left: 0;
		z-index: 2;
		height: 1px;
		margin-left: 225rpx;
		width: 300rpx;
		background: #ccc;
	}

	.crash-goods .h .title {
		display: inline-block;
		position: absolute;
		top: 56.125rpx;
		left: 0;
		z-index: 3;
		height: 33rpx;
		margin-left: 285rpx;
		width: 180rpx;
		background: #fff;
	}

	.crash-goods .b {
		width: 750rpx;
		height: auto;
		overflow: hidden;
	}

	.crash-goods .b .item {
		float: left;
		background: #fff;
		width: 375rpx;
		height: auto;
		overflow: hidden;
		text-align: center;
		padding: 15rpx 31.25rpx;
		border-right: 1px solid #f4f4f4;
		border-bottom: 1px solid #f4f4f4;
	}

	.crash-goods .item .img {
		width: 311.45rpx;
		height: 311.45rpx;
	}

	.crash-goods .item .name {
		display: block;
		width: 311.45rpx;
		height: 35rpx;
		margin: 11.5rpx 0 15rpx 0;
		text-align: center;
		overflow: hidden;
		font-size: 30rpx;
		color: #333;
	}

	.crash-goods .item .goods-do {
		text-align: left;
	}

	.crash-goods .item .goods-do .price {
		/* display: block; */
		/* width: 70.45rpx; */
		/* height: 30rpx; */
		text-align: left;
		font-size: 30rpx;
		color: #b4282d;
		display: inline;
	}

	.crash-goods .item .goods-do .org-price {
		/* display: block; */
		/* width: 70.45rpx; */
		/* height: 23rpx; */
		text-align: left;
		font-size: 30rpx;
		color: #303030;
		display: inline;
	}

	.crash-goods .item .goods-do .add {
		/* width: 93.75rpx; */
		/* height: 100%; */
		text-align: right;
		line-height: 65rpx;
		display: inline;
	}

	/*每组属性的主盒子*/

	.attr_box {
		width: 100%;
		overflow: hidden;
		border-bottom: 1rpx solid #ececec;
		display: flex;
		flex-direction: column;
	}

	/*属性值*/

	.attr_value_box {
		width: 80%;
		float: left;
		padding: 15rpx 0;
		overflow: hidden;
	}

	/*每个属性值*/

	.attr_value {
		float: left;
		padding: 0 30rpx;
		margin: 10rpx 10rpx;
		border: 3rpx solid #ececec;
		border-radius: 5px;
		line-height: 30px;
	}

	/*每个属性选中的当前样式*/

	.attr_value_active {
		border-radius: 10rpx;
		color: #e41f19;
		padding: 0 30rpx;
		border: 3rpx solid #e41f19;
		/* background: #fff;   */
	}

	/*禁用属性*/

	.attr_value_disabled {
		color: #ccc;
	}

	.share-info {
		width: 100%;
		height: 225rpx;
		overflow: hidden;
		margin-bottom: 41.5rpx;
	}

	.share-bottom {
		height: 100%;
		width: 100%;
		background-color: rgba(0, 0, 0, 0.6);
		z-index: 999999;
		left: 0;
		bottom: 0;
		position: relative;
		padding: 60rpx 0 400rpx 0;
	}

	.share-bottom-footer {
		background-color: #FFF;
		align-items: center;
		position: fixed;
		width: 100%;
		left: 0;
		bottom: 0;
	}

	.share-to {
		padding-top: 30rpx;
		font-size: x-large;
		text-align: center;
		width: 100%;
	}

	.imgs {
		display: flex;
		justify-content: center;
		align-items: center;
	}

	.sharebtn_image {
		width: 200rpx;
		height: 200rpx;
	}

	.btn-share {
    height: auto;
		font-size: x-large;
		background-color: #fff;
	}

	.share-bottom button::after {
		border: 0;
	}

	.tui-menu-box {
		box-sizing: border-box;
	}

	.tui-padding {
		padding: 0 30rpx;
		box-sizing: border-box;
	}

	.tui-menu-header {
		font-size: 34rpx;
		color: #fff;
		height: 32px;
		display: flex;
		align-items: center;
	}

	.tui-top-dropdown {
		z-index: 9999 !important;
	}

	.tui-menu-itembox {
		color: #fff;
		padding: 80rpx 10rpx 0 10rpx;
		box-sizing: border-box;
		display: flex;
		flex-wrap: wrap;
	}

	.tui-menu-item {
		font-size: 26rpx;
		width: 22%;
		height: 160rpx;
		border-radius: 24rpx;
		display: flex;
		align-items: center;
		flex-direction: column;
		justify-content: center;
		background: rgba(0, 0, 0, 0.4);
		margin-right: 4%;
		margin-bottom: 4%;
	}

	.tui-menu-item:nth-of-type(4n) {
		margin-right: 0;
	}

	.tui-badge-box {
		position: relative;
	}

	.tui-menu-badge {
		position: absolute;
		top: -8px;
		right: -8px;
	}

	.tui-msg-badge {
		top: -10px;
	}

	.tui-icon-up {
		position: relative;
		display: inline-block;
		left: 50%;
		transform: translateX(-50%);
	}

	.tui-menu-text {
		padding-top: 12rpx;
	}

	.tui-opcity .tui-menu-text,
	.tui-opcity .tui-badge-box {
		opacity: 0.5;
		transition: opacity 0.2s ease-in-out;
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

	.tui-header-icon {
		position: fixed;
		left: 10px;
		top: 0;
		display: flex;
		align-items: flex-start;
		height: 32px;
		transform: translateZ(0);
		z-index: 99999;
	}

	.tui-badge {
		background: #e41f19 !important;
		position: absolute;
		right: -4px;
	}

  .tui-icon-box {
    position: relative;
    height: 20px !important;
    width: 20px !important;
    padding: 6px !important;

    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
  }

	.tui-icon-ml {
		margin-left: 20rpx;
	}

	.tui-icon {
		border-radius: 50%;
	}

	.tui-icon-back {
		height: 32px !important;
		width: 32px !important;
		display: block !important;
	}

	.tui-icon-more {
		height: 20px !important;
		width: 20px !important;
		padding: 6px !important;
		display: block !important;
	}

	/*底部选择弹层*/

	.tui-popup {
		border-top-left-radius: 24rpx;
		border-top-right-radius: 24rpx;
		padding-bottom: env(safe-area-inset-bottom);
	}

	.tui-popup-box {
		position: relative;
		padding: 30rpx 0 100rpx 0;
	}

	.tui-operation-right {
		height: 100rpx;
		/* box-sizing: border-box; */
		padding-top: 0;
	}

	.tui-right-flex {
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.tui-flex {
		flex: 1;
    padding: 20rpx 5rpx;
	}

  .tui-flex-border {
    flex: 1;
    padding: 20rpx 5rpx;
    border: 1px solid #f4f4f4;
  }

	.tui-btn-equals {
		margin: 10rpx;
		display: block !important;
		font-size: 28rpx !important;
	}

	.tui-popup-btn {
		width: 100%;
		position: absolute;
		left: 0;
		bottom: 0;
	}

	.tui-icon-close {
		position: absolute;
		top: 30rpx;
		right: 30rpx;
	}

	.tui-product-box {
		display: flex;
		align-items: flex-end;
		font-size: 24rpx;
	}

	.tui-popup-img {
		height: 200rpx;
		width: 200rpx;
		border-radius: 24rpx;
		display: block;
	}

	.tui-popup-price {
		padding-left: 20rpx;
		padding-bottom: 8rpx;
	}

	.tui-amount {
		color: #ff201f;
		font-size: 36rpx;
	}

	.tui-number {
		font-size: 24rpx;
		line-height: 24rpx;
		padding-top: 12rpx;
		color: #999;
	}

	.tui-popup-scroll {
    height: auto;
		font-size: 26rpx;
	}

	.tui-scrollview-box {
    padding: 0 30rpx;
		box-sizing: border-box;
	}

	.tui-attr-title {
		padding: 10rpx 0;
		color: #333;
	}

	.tui-attr-box {
		font-size: 0;
		padding: 20rpx 0;
	}

	.tui-attr-item {
		max-width: 100%;
		min-width: 200rpx;
		height: 64rpx;
		display: -webkit-inline-flex;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		background: #f7f7f7;
		padding: 0 26rpx;
		box-sizing: border-box;
		border-radius: 32rpx;
		margin-right: 20rpx;
		margin-bottom: 20rpx;
		font-size: 26rpx;
	}

	.tui-attr-item-disabled {
		border: 1px solid #ccc;
		color: #ccc;
	}

	.tui-attr-item-active {
		background: #fcedea !important;
		color: #e41f19;
		font-weight: bold;
		position: relative;
	}

	.tui-attr-item-active::after {
		content: "";
		position: absolute;
		border: 2rpx solid #e41f19;
		width: 100%;
		height: 100%;
		border-radius: 40rpx;
		left: 0;
		top: 0;
	}

	.tui-number-box {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 20rpx 0 30rpx 0;
		box-sizing: border-box;
	}

	/*海报modal弹层*/
	.tui-poster__canvas {
		background-color: #fff;
		position: absolute;
		left: -9999px;
	}

	.tui-poster__box {
		width: 100%;
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
		flex-direction: column;
	}

	.tui-close__img {
		width: 48rpx;
		height: 48rpx;
		position: absolute;
		right: 0;
		top: -60rpx;
	}

	.tui-poster__img {
		width: 560rpx;
		height: 890rpx;
		border-radius: 20rpx;
		margin-bottom: 40rpx;
	}

	.tui-share__tips {
		font-size: 24rpx;
		transform: scale(0.8);
		transform-origin: center center;
		color: #ffffff;
		padding-top: 12rpx;
	}
</style>

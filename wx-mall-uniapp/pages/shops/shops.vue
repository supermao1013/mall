<template>
	<view class="container">
		<view class="main">
			<view class="nav">
				<view class="header">
					<view class="left">
						<view class="store-name">
							<text>{{ shopsVo.name||''}}</text>
							<view class="description" v-if="shopsVo.telephone" :data-phone="shopsVo.telephone"
								@tap="openCall">
								<tui-icon name="voipphone" color="#ADB838" :data-phone="shopsVo.telephone" :size="18">
								</tui-icon>
							</view>
						</view>
						<view class="coupon">
							<text class="title">营业时间 {{shopsVo.workTime||''}}</text>
						</view>
						<view class="store-location" :data-longitude="shopsVo.longitude"
							:data-latitude="shopsVo.latitude" :data-name="shopsVo.name" :data-address="shopsVo.details"
							@tap="goHere">
							<image src='/static/images/mall/icon_address.png' style="width: 30rpx; height: 30rpx;"
								class="mr-10"></image>
							<text>{{shopsVo.details||''}} (距离您 {{ distant }} 公里)</text>
						</view>
					</view>
<!--					<view class="right">-->
<!--						<view class="takeout active">-->
<!--							<text>自取</text>-->
<!--						</view>-->
<!--					</view>-->
				</view>
			</view>
			<view class="content" v-if="goods.length">
				<scroll-view class="menus" :scroll-into-view="menuScrollIntoView" scroll-with-animation scroll-y>
					<view class="wrapper">
						<view class="menu" :id="`menu-${item.id}`" :class="{'current': item.id === currentCateId}"
							v-for="(item, index) in goods" :key="index" @tap="handleMenuTap(item.id)">
							<text>{{ item.name }}</text>
							<view class="dot" v-show="menuCartNum(item.id)">{{ menuCartNum(item.id) }}</view>
						</view>
					</view>
				</scroll-view>
				<!-- goods list begin -->
				<scroll-view class="goods" scroll-with-animation scroll-y :scroll-top="cateScrollTop"
					@scroll="handleGoodsScroll">
					<view class="wrapper">
						<swiper class="ads" id="ads" autoplay :interval="3000" indicator-dots>
							<swiper-item>
								<image :src="shopsVo.imgUrl"></image>
							</swiper-item>
						</swiper>
						<view class="list">
							<!-- category begin -->
							<view class="category" v-for="(item, index) in goods" :key="index" :id="`cate-${item.id}`">
								<view class="title">
									<text>{{ item.name }}</text>
									<image :src="item.icon" class="icon"></image>
								</view>
								<view class="items">
									<!-- 商品 begin -->
									<view class="good" v-for="(good, key) in item.shopsGoodsList" :key="key" @tap="handleAddToCart(item, good, 1)">
										<image :src="good.listPicUrl" class="image"></image>
										<view class="right">
											<text class="name">{{ good.name }}</text>
											<text class="tips">{{ good.goodsBrief }}</text>
											<view class="price_and_action">
												<text class="price">￥{{ good.retailPrice }}</text>
												<view class="btn-group">
												</view>
											</view>
										</view>
									</view>
									<!-- 商品 end -->
								</view>
							</view>
							<!-- category end -->
						</view>
					</view>
				</scroll-view>
				<!-- goods list end -->
			</view>
			<tui-show-empty text="暂无商品" v-else></tui-show-empty>
		</view>
		<!-- content end -->
		<!-- 购物车栏 begin -->
		<view class="cart-box" v-if="footCart.cartTotal.goodsCount > 0">
			<view class="mark">
				<image src="/static/images/mall/cart.png" class="cart-img" @tap="openCartPage"></image>
				<view class="tag">{{ footCart.cartTotal.goodsCount }}</view>
			</view>
			<view class="price">￥{{ footCart.cartTotal.checkedGoodsAmount }}</view>
			<button type="warn" class="pay-btn" @tap="openCartPage">
				去结算
			</button>
		</view>
		<!-- 购物车栏 end -->
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				goods: [], //所有商品
				currentCateId: '', //默认分类
				cateScrollTop: 0,
				menuScrollIntoView: '',
				cart: [], //购物车
				good: {}, //当前饮品
				sizeCalcState: false,
				goodsList: [],
				shopsSn: '',
				shopsVo: {},
				footCart: {
					cartTotal: {}
				},
				distant: ''
			}
		},
		computed: {
			goodCartNum() { //计算单个饮品添加到购物车的数量
				return (id) => this.cart.reduce((acc, cur) => {
					if (cur.goodsId === id) {
						return acc += cur.number
					}
					return acc
				}, 0)
			},
			menuCartNum() {
				return (id) => this.cart.reduce((acc, cur) => {
					if (cur.shopsCategoryId === id) {
						return acc += cur.number
					}
					return acc
				}, 0)
			}
		},
		methods: {
			handleMenuTap(id) { //点击菜单项事件
				if (!this.sizeCalcState) {
					this.calcSize()
				}

				this.currentCateId = id
				this.$nextTick(() => this.cateScrollTop = this.goods.find(item => item.id == id).top)
			},
			handleGoodsScroll({
				detail
			}) { //商品列表滚动事件
				if (!this.sizeCalcState) {
					this.calcSize()
				}
				const {
					scrollTop
				} = detail
				let tabs = this.goods.filter(item => item.top <= scrollTop).reverse()
				if (tabs.length > 0) {
					this.currentCateId = tabs[0].id
				}
			},
			handleReduceFromCart(item, good) {
				let that = this;
				const index = this.cart.findIndex(item => item.goodsId === good.goodsId)
				this.cart[index].number -= 1
				if (this.cart[index].number <= 0) {
					this.cart.splice(index, 1)
				}
				util.request('cart/minus', {
					goodsId: good.goodsId,
					number: 1,
					shopsId: that.shopsVo.id,
				}, 'POST').then(function(res) {
					if (res.code === 0 && null != res.data) {
						var goodsList = that.goodsList;
						goodsList.forEach(function(val, index, arr) {
							if (val.goodsId == good.goodsId) {
								val.cartNum = res.data;
								goodsList[index] = val;
							}
						}, that);
						that.goodsList = goodsList
						that.getMycart();
					}
				});
			},
			handleAddToCart(cate, good, num) { //添加到购物车
				let that = this;
				uni.navigateTo({
					url: '/pages/goods/goods?id=' + good.id,
				})
			},
			calcSize() {
				let h = 10
				let view = uni.createSelectorQuery().select('#ads')
				view.fields({
					size: true
				}, data => {
					h += Math.floor(data.height)
				}).exec()

				this.goods.forEach(item => {
					let view = uni.createSelectorQuery().select(`#cate-${item.id}`)
					view.fields({
						size: true
					}, data => {
						item.top = h
						h += data.height
						item.bottom = h
					}).exec()
				})
				this.sizeCalcState = true
			},
			getShopsDetail: function() {
				let that = this;
				util.request('shops/detailBySn', {
					shopsSn: that.shopsSn
				}).then(function(res) {
					if (res.code === 0) {
						that.shopsVo = res.data
						that.getMycart();
						util.request('shops/shopsCategory', {
							shopsId: that.shopsVo.id
						}).then(function(res) {
							if (res.code === 0) {
								that.goods = res.data
								if (res.data.length > 0) {
									//默认激活第一条
									that.currentCateId = res.data[0].id
								}
							} else {
								//显示错误信息
								util.toast(res.data.errmsg);
							}
						});
						uni.getLocation({
							type: 'gcj02',
							success(data) {
								let shopsVo = res.data;
								that.distant = util.getDistance(data.latitude, data.longitude,
									shopsVo.latitude, shopsVo.longitude)
								that.shopsVo = shopsVo
							}
						})
					} else {
						//显示错误信息
						util.toast(res.errmsg);
					}
				});
			},
			goHere: function(e) {
				uni.openLocation({
					name: e.currentTarget.dataset.name,
					address: e.currentTarget.dataset.address,
					latitude: parseFloat(e.currentTarget.dataset.latitude),
					longitude: parseFloat(e.currentTarget.dataset.longitude)
				})
			},
			getMycart: function() {
				let that = this;
				if (that.shopsVo && that.shopsVo.id) {
					util.request('cart/myCart', {
						shopsId: that.shopsVo.id
					}).then(function(resp) {
						if (resp.code === 0) {
							that.footCart = resp
							that.cart = resp.cartList
						}
					});
				}
			},
			openCartPage: function() {
				let that = this;
				uni.switchTab({
					url: '/pages/cart/cart',
				})
			},
			openCall: function(e) {
				uni.makePhoneCall({
					phoneNumber: e.target.dataset.phone
				})
			}
		},
		onShow: function() {
			// 页面显示
			this.getShopsDetail();
		},
		onLoad: function(options) {
			uni.setStorageSync("navUrl", "/pages/shops/shops?shopsSn=" + options.shopsSn);
			// 页面初始化 options为页面跳转所带来的参数
			var that = this;
			if (options.shopsSn) {
				that.shopsSn = options.shopsSn;
			}
		},
		onShareAppMessage: function() {
			var that = this;
			return {
				title: that.shopsVo.name,
				desc: that.shopsVo.details,
				path: '/pages/shops/shops?shopsSn=' + that.shopsSn
			}
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			this.getShopsDetail();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		}
	}
</script>
<style lang="scss" scoped>
	@import '~@/pages/shops/shops.scss';
</style>

<template>
	<view class="container">
		<!--header-->
		<view class="tui-header-box">
			<view class="tui-header" :style="{ width: width + 'px', height: height + 'px' }">
        <!-- #ifndef MP-ALIPAY -->
				<view class="tui-back" :style="{ marginTop: arrowTop + 'px' }" @tap="back">
					<tui-icon name="arrowleft" color="#000"></tui-icon>
				</view>
        <!-- #endif -->
				<view class="tui-searchbox tui-search-mr" :style="{ marginTop: inputTop + 'px' }">
					<icon type="search" :size="13" color="#999"></icon>
					<view class="tui-search-key">
						<input confirm-type="search" v-model.trim="keyword" :auto-focus="searchStatus==1"
							placeholder="搜索商品" class="tui-input-class" @confirm="onKeywordConfirm"
							@tap="searchStatus=1" />
						<tui-icon :style="{ left: (width - 40) + 'px' }" class="shut-icon" name="shut" :size="15" color="#999" v-if="keyword" @click="clearKeyword"></tui-icon>
					</view>
				</view>
			</view>
		</view>
		<!--header-->
		<view v-if="searchStatus==2">
			<!--screen-->
			<view class="tui-header-screen" :style="{ top: height + 'px' }">
				<view class="tui-screen-top">
					<view class="tui-top-item tui-icon-ml" :class="[tabIndex == 0 ? 'tui-active tui-bold' : '']"
						data-index="0" @tap="screen">
						<view>{{ selectedName }}</view>
						<tui-icon :name="selectH > 0 ? 'arrowup' : 'arrowdown'" :size="14"
							:color="tabIndex == 0 ? '#e41f19' : '#444'"></tui-icon>
					</view>
					<view class="tui-top-item" :class="[tabIndex == 1 ? 'tui-active tui-bold' : '']" @tap="screen"
						data-index="1">销量</view>
					<view class="tui-top-item" @tap="screen" data-index="2">
						<tui-icon :name="isList ? 'manage' : 'listview'" :size="isList ? 22 : 18"
							:bold="isList ? false : true" color="#333"></tui-icon>
					</view>
					<view class="tui-top-item tui-icon-ml" @tap="screen" data-index="3">
						<text>筛选</text>
						<tui-icon name="screen" :size="12" color="#333" :bold="true"></tui-icon>
					</view>

					<!--下拉选择列表--综合-->
					<view class="tui-dropdownlist" :class="[selectH > 0 ? 'tui-dropdownlist-show' : '']"
						:style="{ height: selectH + 'rpx' }">
						<view class="tui-dropdownlist-item tui-icon-middle"
							:class="[selectPrice === 'zonghe' ? 'tui-bold' : '']" @tap.stop="selectPriceTap('zonghe')">
							<text class="tui-ml tui-middle"> 综合 </text>
							<tui-icon name="check" :size="16" color="#e41f19" :bold="true"
								v-if="selectPrice === 'zonghe' ">
							</tui-icon>
						</view>
						<view class="tui-dropdownlist-item tui-icon-middle"
							:class="[selectPrice === 'asc' ? 'tui-bold' : '']" @tap.stop="selectPriceTap('asc')">
							<text class="tui-ml tui-middle"> 价格升序 </text>
							<tui-icon name="check" :size="16" color="#e41f19" :bold="true" v-if="selectPrice === 'asc'">
							</tui-icon>
						</view>
						<view class="tui-dropdownlist-item tui-icon-middle"
							:class="[selectPrice === 'desc' ? 'tui-bold' : '']" @tap.stop="selectPriceTap('desc')">
							<text class="tui-ml tui-middle"> 价格降序 </text>
							<tui-icon name="check" :size="16" color="#e41f19" :bold="true"
								v-if="selectPrice === 'desc'">
							</tui-icon>
						</view>
					</view>
					<view class="tui-dropdownlist-mask" :class="[selectH > 0 ? 'tui-mask-show' : '']"
						@tap.stop="hideDropdownList"></view>
					<!--下拉选择列表--综合-->
				</view>
				<view class="tui-screen-bottom">
					<view class="tui-bottom-item tui-icon-ml" :class="[type == 'IS_NEW' ? 'tui-btmItem-active' : '']"
						@tap="newSelectSerach">
						<view class="tui-bottom-text">
							新品
						</view>
					</view>
					<view class="tui-bottom-item tui-icon-ml" :class="[brandSelect ? 'tui-btmItem-active' : '']"
						@tap="brandSelectSerach">
						<view class="tui-bottom-text" :class="[attrIndex == 1 ? 'tui-active' : '']">
							{{ selectedBrandName }}
						</view>
						<tui-icon :name="attrIndex == 1 ? 'arrowup' : 'arrowdown'" :size="14"
							:color="attrIndex == 1 || brandSelect ? '#e41f19' : '#444'" v-if="brandList.length > 0">
						</tui-icon>
					</view>
					<view class="tui-bottom-item tui-icon-ml" :class="[categorySelect ? 'tui-btmItem-active' : '']"
						@tap="categorySelectSerach">
						<view class="tui-bottom-text" :class="[attrIndex == 2 ? 'tui-active' : '']">
							{{ selectedCategoryName }}
						</view>
						<tui-icon :name="attrIndex == 2 ? 'arrowup' : 'arrowdown'" :size="14"
							:color="attrIndex == 2 || categorySelect ? '#e41f19' : '#444'"
							v-if="categoryList.length > 0">
						</tui-icon>
					</view>
				</view>
			</view>
			<!--screen-->

			<!--顶部下拉筛选弹层 属性-->
			<tui-top-dropdown backgroundColor="#f7f7f7" :show="dropBrandScreenShow" :paddingbtm="110"
				:translatey="dropScreenH" @close="btnBrandCloseDrop">
				<scroll-view class="tui-scroll-box" scroll-y :scroll-top="scrollTop">
					<view class="tui-seizeaseat-20"></view>
					<view v-for="(item, index) in brandList" :key="index" class="tui-drop-item tui-icon-middle"
						:class="[item.selected ? 'tui-bold' : '']" @tap.stop="brandSelected" :data-index="index">
						<tui-icon name="check" :size="16" color="#e41f19" :bold="true" v-if="item.selected"></tui-icon>
						<text class="tui-ml tui-middle">{{ item.name }}</text>
					</view>
					<view class="tui-seizeaseat-30"></view>
				</scroll-view>
				<view class="tui-drop-btnbox">
					<view class="tui-drop-btn tui-btn-white" hover-class="tui-white-hover" :hover-stay-time="150"
						@tap="resetBrand">重置</view>
					<view class="tui-drop-btn tui-btn-red" hover-class="tui-red-hover" :hover-stay-time="150"
						@tap="brandSelectedSure">确定</view>
				</view>
			</tui-top-dropdown>
			<!---顶部下拉筛选弹层 属性-->

			<!--顶部下拉筛选弹层 属性-->
			<tui-top-dropdown backgroundColor="#f7f7f7" :show="dropCategoryScreenShow" :paddingbtm="110"
				:translatey="dropScreenH" @close="btnCategoryCloseDrop">
				<scroll-view class="tui-scroll-box" scroll-y :scroll-top="scrollTop">
					<view class="tui-seizeaseat-20"></view>
					<view v-for="(item, index) in categoryList" :key="index" class="tui-drop-item tui-icon-middle"
						:class="[item.selected ? 'tui-bold' : '']" @tap.stop="categorySelected" :data-index="index">
						<tui-icon name="check" :size="16" color="#e41f19" :bold="true" v-if="item.selected"></tui-icon>
						<text class="tui-ml tui-middle">{{ item.name }}</text>
					</view>
					<view class="tui-seizeaseat-30"></view>
				</scroll-view>
				<view class="tui-drop-btnbox">
					<view class="tui-drop-btn tui-btn-white" hover-class="tui-white-hover" :hover-stay-time="150"
						@tap="resetCategory">重置</view>
					<view class="tui-drop-btn tui-btn-red" hover-class="tui-red-hover" :hover-stay-time="150"
						@tap="categorySelectedSure">确定</view>
				</view>
			</tui-top-dropdown>
			<!---顶部下拉筛选弹层 属性-->

			<!--list-->
			<view class="tui-product-list" v-if="productList.length >0" :style="{ marginTop: px(dropScreenH + 18) }">
				<view class="tui-product-container">
					<block v-for="(item, index) in productList" :key="index" v-if="(index + 1) % 2 != 0 || isList">
						<!-- <template is="productItem" data="{{item,index:index,isList:isList}}" /> -->
						<!--商品列表-->
						<image src="/static/images/mall/new.png" class="tui-new-label" v-if="item.isNew===1"></image>
						<view class="tui-pro-item" :class="[isList ? 'tui-flex-list' : '']" hover-class="hover"
							:hover-start-time="150" @tap="goodsDetail" :data-id="item.id">
							<image :src="item.listPicUrl" class="tui-pro-img" :class="[isList ? 'tui-proimg-list' : '']"
								mode="widthFix" />
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
						<!--商品列表-->
					</block>
				</view>
				<view class="tui-product-container" v-if="!isList">
					<block v-for="(item, index) in productList" :key="index" v-if="(index + 1) % 2 == 0">
						<!-- <template is="productItem" data="{{item,index:index}}" /> -->
						<!--商品列表-->
						<image src="/static/images/mall/new.png" class="tui-new-label" v-if="item.isNew===1"></image>
						<view class="tui-pro-item" :class="[isList ? 'tui-flex-list' : '']" hover-class="hover"
							:hover-start-time="150" @tap="goodsDetail" :data-id="item.id">
							<image :src="item.listPicUrl" class="tui-pro-img" :class="[isList ? 'tui-proimg-list' : '']"
								mode="widthFix" />
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
						<!--商品列表-->
					</block>
				</view>
			</view>
			<!--list-->
			<tui-show-empty v-else text="您寻找的商品还未上架" :top="500"></tui-show-empty>
		</view>
		<view v-else-if="searchStatus===1" :style="{ marginTop: height + 'px',padding: '20rpx' }">
			<view class="tui-search-history" v-if="history.length>0">
				<view class="tui-history-header">
					<view class="tui-search-title">搜索历史</view>
					<tui-icon name="delete" :size='14' color='#333' @click="openActionSheet" class="tui-icon-delete">
					</tui-icon>
				</view>
				<view class="tui-history-content">
					<view v-for="(item,index) in history" :key="index" @tap="onKeywordTap('', item)">
						<tui-tag margin="0 24rpx 24rpx 0" type="gray" shape="circle">{{item}}</tui-tag>
					</view>
				</view>
			</view>
			<view class="tui-search-hot">
				<view class="tui-hot-header">
					<view class="tui-search-title">大家正在搜</view>
				</view>
				<view class="tui-history-content">
					<view v-for="(item,index) in hot" :key="index" @tap="onKeywordTap(item.SCHEME_URL, item.KEYWORD)">
						<tui-tag margin="0 24rpx 24rpx 0" type="gray" shape="circle">{{item.KEYWORD}}</tui-tag>
					</view>
				</view>
			</view>
		</view>
		<!--左抽屉弹层 筛选 -->
		<tui-drawer mode="right" :visible="drawer" @close="closeDrawer">
			<view class="tui-drawer-box" :style="{ paddingTop: height + 'px' }">
				<scroll-view class="tui-drawer-scroll" scroll-y :style="{ height: drawerH + 'px'}">
					<view class="tui-drawer-title">
						<text class="tui-title-bold">价格区间</text>
					</view>
					<view class="tui-drawer-content">
						<input placeholder-class="tui-phcolor" class="tui-input" placeholder="最低价" maxlength="11"
							v-model="minPrice" type="number" @blur="checkPrice(1)" />
						<tui-icon name="reduce" color="#333" :size="14"></tui-icon>
						<input placeholder-class="tui-phcolor" class="tui-input" placeholder="最高价" maxlength="11"
							v-model="maxPrice" type="number" @blur="checkPrice(2)" />
					</view>

					<view class="tui-drawer-title">
						<text class="tui-title-bold">全部分类</text>
						<view class="tui-all-box tui-icon-ml">
							<view class="tui-attr-right" @tap.stop="categoryAll=!categoryAll">全部</view>
							<tui-icon :name="categoryAll ? 'arrowup' : 'arrowdown'" :size="14" color="#444"></tui-icon>
						</view>
					</view>
					<view class="tui-drawer-content tui-flex-attr" v-show="categoryAll">
						<view class="tui-attr-item" :class="[item.selected ? 'tui-btmItem-active' : '']"
							v-for="(item,index) in categoryList" :key="index" @tap.stop="categorySelected"
							:data-index="index">
							<view class="tui-attr-ellipsis">{{item.name}}</view>
						</view>
					</view>

					<view class="tui-drawer-title">
						<text class="tui-title-bold">品牌</text>
						<view class="tui-all-box tui-icon-ml">
							<view class="tui-attr-right" @tap.stop="brandAll=!brandAll">全部</view>
							<tui-icon :name="brandAll ? 'arrowup' : 'arrowdown'" :size="14" color="#444"></tui-icon>
						</view>
					</view>
					<view class="tui-drawer-content tui-flex-attr" v-show="brandAll">
						<view class="tui-attr-item" :class="[item.selected ? 'tui-btmItem-active' : '']"
							v-for="(item,index) in brandList" :key="index" @tap.stop="brandSelected"
							:data-index="index">
							<view class="tui-attr-ellipsis">{{item.name}}</view>
						</view>
					</view>
					<view class="tui-safearea-bottom"></view>
				</scroll-view>
				<view class="tui-attr-btnbox">
					<view class="tui-attr-safearea">
						<view class="tui-drawer-btn tui-drawerbtn-black" hover-class="tui-white-hover"
							:hover-stay-time="150" @tap="resetAll">重置</view>
						<view class="tui-drawer-btn tui-drawerbtn-primary" hover-class="tui-red-hover"
							:hover-stay-time="150" @tap="closeDrawer">确定</view>
					</view>
				</view>
			</view>
		</tui-drawer>
		<!--左抽屉弹层 筛选-->

		<tui-actionsheet :show="showActionSheet" :tips="tips" @click="cleanHistory" @cancel="closeActionSheet">
		</tui-actionsheet>
		<!--加载loadding-->
		<tui-loadmore v-if="loadding" :index="3" type="red"></tui-loadmore>
		<tui-nomore v-if="!pullUpOn" backgroundColor="#f7f7f7"></tui-nomore>
		<!--加载loadding-->
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				categoryId: '',
				pId: '',
				selectPrice: 'zonghe',
				productList: [],
				current: 1,
				limit: 20,
				minPrice: 0,
				maxPrice: 0,
				pages: '', // 总页数
				keyword: '', //搜索关键词
				type: '', // 类型：IS_HOT：热销商品；IS_NEW：新品推荐
				order: '', // 排序字段 PRICE,SALES
				sortType: '', // 排序类型 ASC,DESC
				categoryAll: true, // 显示所有分类
				brandAll: true, // 显示所有品牌
				brandList: [],
				brandSelect: false, // 是否选中品牌
				brandIds: [],
				selectedBrandName: '品牌',
				categoryList: [],
				categorySelect: false, // 是否选中分类
				categoryIds: [],
				selectedCategoryName: '分类',
				searchStatus: 0,
				hot: [],
				history: [],
				showActionSheet: false,
				tips: "确认清空搜索历史吗？",
				width: 200, //header宽度
				height: 64, //header高度
				inputTop: 0, //搜索框距离顶部距离
				arrowTop: 0, //箭头距离顶部距离
				dropScreenH: 0, //下拉筛选框距顶部距离
				attrIndex: -1,
				dropBrandScreenShow: false,
				dropCategoryScreenShow: false,
				scrollTop: 0,
				tabIndex: 0, //顶部筛选索引
				isList: false, //是否以列表展示  | 列表或大图
				drawer: false,
				drawerH: 0, //抽屉内部scrollview高度
				selectedName: '综合',
				selectH: 0,
				loadding: false,
				pullUpOn: true
			};
		},
		onLoad: function(options) {
			uni.setStorageSync("navUrl", "/pages/category/category");
			let obj = {};
			// #ifdef MP-WEIXIN
			obj = wx.getMenuButtonBoundingClientRect();
			// #endif
			// #ifdef MP-BAIDU
			obj = swan.getMenuButtonBoundingClientRect();
			// #endif
			// #ifdef MP-ALIPAY
			my.hideAddToDesktopMenu();
			// #endif
			uni.getSystemInfo({
				success: res => {
					this.width = obj.left || res.windowWidth;
					this.height = obj.top ? obj.top + obj.height + 8 : res.statusBarHeight + 44;
					this.inputTop = obj.top ? obj.top + (obj.height - 30) / 2 : res.statusBarHeight + 7;
					this.arrowTop = obj.top ? obj.top + (obj.height - 32) / 2 : res.statusBarHeight + 6;
					//略小，避免误差带来的影响
					this.dropScreenH = (this.height * 750) / res.windowWidth + 186;
					this.drawerH = res.windowHeight - uni.upx2px(100) - this.height;
				}
			});
			// 页面初始化 options为页面跳转所带来的参数
			let that = this;
			if (options.categoryId) {
				that.categoryIds.push(options.categoryId)
			}
			if (options.brandId) {
				that.brandIds.push(options.brandId)
			}
			if (options.keyword) {
				that.keyword = options.keyword
			}
			if (options.type) {
				that.type = options.type
			}
			if (options.showSearchHistory) {
        that.refreshHistory()
			} else {
				that.searchStatus = 2
				that.getGoodsList();
			}
			that.getBrands();
			that.getCategorys();
      that.getHistory();
		},
		onPullDownRefresh: function() {
			this.current = 1;
			this.pullUpOn = true;
			this.loadding = false;
			this.getGoodsList();
			uni.stopPullDownRefresh();
		},
		onReachBottom: function() {
			this.loadding = true;
			if (this.current == this.pages) {
				this.loadding = false;
				this.pullUpOn = false;
			} else {
				this.getGoodsList(true);
				this.loadding = false;
			}
		},
		methods: {
      refreshHistory() {
        let that = this;
        that.searchStatus = 1
        that.getHistory();
      },
			openActionSheet: function() {
				this.showActionSheet = true
			},
			closeActionSheet: function() {
				this.showActionSheet = false
			},
			cleanHistory: function() {
				let that = this;
				util.request('search/clearHistory', {}, 'POST').then(function(res) {
          if (res.code === 0) {
            that.showActionSheet = false;
            that.history = []
          }
				});
			},
			getHistory() {
				let that = this;
				util.request('search/history').then(function(res) {
					if (res.code === 0) {
						that.hot = res.hotKeywordList
						that.history = res.historyKeywordList
					}
				});
			},
			clearKeyword: function() {
				this.keyword = ''
        this.refreshHistory()
			},
			resetAll() {
				this.minPrice = 0
				this.maxPrice = 0
				this.resetBrand()
				this.resetCategory()
			},
			checkPrice(type) {
				if (type === 1)
					this.minPrice = util.replaceAll(util.rmoney(this.minPrice), ',', '')
				else
					this.maxPrice = util.replaceAll(util.rmoney(this.maxPrice), ',', '')

			},
			resetBrand() {
				this.brandIds = []
				this.brandSelect = false
				this.selectedBrandName = '品牌'
				this.getBrands()
			},
			getBrands: function() {
				let that = this;
				util.request('brand/brandAll').then(function(res) {
					if (res.code === 0) {
						that.brandList = res.data
						if (that.brandIds.length > 0) {
							let attrName = '';
							let active = false;
							for (let brand of that.brandList) {
								for (let brandId of that.brandIds) {
									if (brand.id == brandId) {
										active = true;
										brand.selected = true
										attrName += attrName ? ';' + brand.name : brand.name;
									}
								}
							}
							that.brandSelect = active
							that.selectedBrandName = attrName || '品牌'
						}
					}
				})
			},
			resetCategory() {
				this.categoryIds = []
				this.categorySelect = false
				this.selectedCategoryName = '分类'
				this.getCategorys()
			},
			getCategorys: function() {
				let that = this;
				util.request('category/categoryList', {
					level: 2
				}).then(function(res) {
					if (res.code === 0) {
						that.categoryList = res.data
						if (that.categoryIds.length > 0) {
							let attrName = '';
							let active = false;
							for (let category of that.categoryList) {
								for (let categoryId of that.categoryIds) {
									if (category.id == categoryId) {
										active = true;
										category.selected = true
										attrName += attrName ? ';' + category.name : category.name;
									}
								}
							}
							that.categorySelect = active
							that.selectedCategoryName = attrName || '分类'
						}
					}
				})
			},
			getGoodsList: function(reachBottom) {
				let that = this;
				let loadData;
				that.pullUpOn = true;
				if (reachBottom) {
					loadData = JSON.parse(JSON.stringify(that.productList));
					that.current = that.current + 1;
				}
				util.request('search/seachList', {
					type: that.type,
					keyword: that.keyword,
					searchFrom: util.getFromType(),
					categoryIds: that.categoryIds.join(','),
					current: that.current,
					limit: that.limit,
					order: that.order,
					sortType: that.sortType,
					brandIds: that.brandIds.join(','),
					minPrice: that.minPrice,
					maxPrice: that.maxPrice
				}).then(function(res) {
          if (res.code === 0) {
            that.searchStatus = 2;
            that.productList = res.data.records
            that.pages = res.data.pages
            if (reachBottom) {
              that.productList = loadData.concat(res.data.records);
            }
          }
				});
			},
			newSelectSerach() {
				let that = this;
				if (that.type === 'IS_NEW') {
					that.type = ''
				} else {
					that.type = 'IS_NEW'
				}
				that.getGoodsList()
			},
			brandSelectSerach() {
				let that = this;
				that.attrIndex = 1
				that.dropCategoryScreenShow = false;
				if (that.brandList.length === 0) {
					that.btnBrandCloseDrop();
				} else {
          that.dropBrandScreenShow = !that.dropBrandScreenShow;
					that.scrollTop = 1;
					that.$nextTick(() => {
						that.scrollTop = 0;
					});
				}
			},
			categorySelectSerach() {
				let that = this;
				that.attrIndex = 2
        that.dropCategoryScreenShow = !that.dropCategoryScreenShow;
				if (that.categoryList.length === 0) {
					that.btnCategoryCloseDrop();
				} else {
					that.dropCategoryScreenShow = true;
					that.scrollTop = 1;
					that.$nextTick(() => {
						that.scrollTop = 0;
					});
				}
			},
			onKeywordConfirm() {
				let that = this;
				that.current = 1;
				that.order = ''
				that.sortType = ''
				that.productList = [];
				that.getGoodsList();
			},
			onKeywordTap: function(url, keyword) {
				if (url) {
					uni.navigateTo({
						url: url
					})
				} else {
					this.keyword = keyword
					this.onKeywordConfirm();
				}
			},
			selectPriceTap: function(selectPrice) {
				let that = this;
				that.selectPrice = selectPrice;
				that.selectedName = selectPrice === 'zonghe' ? '综合' : '价格';
				that.selectH = 0;
				that.current = 1;
				if (selectPrice === 'zonghe') {
					that.order = ''
					that.sortType = ''
					that.getGoodsList();
				} else {
					that.sortType = selectPrice
					that.order = 'SALES'
					that.getGoodsList()
				}
			},
			goodsDetail: function(event) {
				let goodsId = event.currentTarget.dataset.id;
				uni.navigateTo({
					url: '/pages/goods/goods?id=' + goodsId,
				})
			},
			px(num) {
				return uni.upx2px(num) + 'px';
			},
			screen: function(e) {
				let that = this;
				let index = e.currentTarget.dataset.index;
				that.hideDropdownList();
				that.btnBrandCloseDrop();
				that.btnCategoryCloseDrop();
				if (index == 0) {
					that.showDropdownList();
				} else if (index == 1) {
					that.tabIndex = 1;
					that.current = 1;
					that.order = 'SALES'
					that.sortType = 'DESC'
					that.getGoodsList()
				} else if (index == 2) {
					that.isList = !that.isList;
				} else if (index == 3) {
					that.drawer = true;
				}
			},
			showDropdownList: function() {
				this.selectH = 246;
				this.tabIndex = 0;
			},
			hideDropdownList: function() {
				this.selectH = 0;
			},
			closeDrawer: function() {
				this.drawer = false;
				this.getGoodsList()
			},
			back: function() {
				if (this.searchStatus == 1) {
					this.searchStatus = 2
				} else if (this.drawer) {
					this.closeDrawer();
				} else {
					uni.navigateBack({
            fail: function fail(res) {
              uni.switchTab({
                url: '/pages/index/index'
              });
            }
          });
				}
			},
			brandSelected: function(e) {
				let index = e.currentTarget.dataset.index;
				this.$set(this.brandList[index], 'selected', !this.brandList[index].selected);
			},
			categorySelected: function(e) {
				let index = e.currentTarget.dataset.index;
				this.$set(this.categoryList[index], 'selected', !this.categoryList[index].selected);
			},
			brandSelectedSure: function() {
				let that = this;
				let arr = that.brandList;
				let active = false;
				let attrName = '';
				let brandIds = []
				//这里只是为了展示选中效果,并非实际场景
				for (let item of arr) {
					if (item.selected) {
						active = true;
						attrName += attrName ? ';' + item.name : item.name;
						brandIds.push(item.id)
					}
				}
				that.brandIds = brandIds;
				that.btnBrandCloseDrop();
				that.brandSelect = active
				that.selectedBrandName = attrName || '品牌'
				that.current = 1;
				that.getGoodsList();
			},
			categorySelectedSure: function() {
				let that = this;
				let arr = that.categoryList;
				let active = false;
				let attrName = '';
				let categoryIds = []
				//这里只是为了展示选中效果,并非实际场景
				for (let item of arr) {
					if (item.selected) {
						active = true;
						attrName += attrName ? ';' + item.name : item.name;
						categoryIds.push(item.id)
					}
				}
				that.categoryIds = categoryIds;
				that.btnCategoryCloseDrop();
				that.categorySelect = active
				that.selectedCategoryName = attrName || '分类'
				that.current = 1;
				that.getGoodsList();
			},
			btnBrandCloseDrop() {
				this.scrollTop = 1;
				this.$nextTick(() => {
					this.scrollTop = 0;
				});
				this.dropBrandScreenShow = false;
				this.attrIndex = -1;

			},
			btnCategoryCloseDrop() {
				this.scrollTop = 1;
				this.$nextTick(() => {
					this.scrollTop = 0;
				});
				this.dropCategoryScreenShow = false;
				this.attrIndex = -1;
			}
		}
	};
</script>

<style>
	page {
		background-color: #f7f7f7;
	}

	.container {
		padding-bottom: env(safe-area-inset-bottom);
	}

	/* 隐藏scroll-view滚动条*/

	::-webkit-scrollbar {
		width: 0;
		height: 0;
		color: transparent;
	}

	.tui-header-box {
		width: 100%;
		background: #fff;
		position: fixed;
		z-index: 99998;
		left: 0;
    /* #ifdef MP-ALIPAY */
    padding-left: 80rpx;
    /* #endif */
		top: 0;
	}

	.tui-header {
		display: flex;
		align-items: flex-start;
	}

	.tui-back {
		margin-left: 8rpx;
		height: 32px !important;
		width: 32px !important;
	}

	.tui-searchbox {
		height: 30px;
		margin-right: 30rpx;
		border-radius: 15px;
		font-size: 12px;
		background: #f7f7f7;
		padding: 3px 10px;
		box-sizing: border-box;
		color: #999;
		display: flex;
		align-items: center;
		overflow: hidden;
	}

	/* #ifdef MP */
	.tui-search-mr {
		margin-right: 20rpx !important;
	}
	/* #endif */

	.tui-search-text {
		padding-left: 16rpx;
	}

	.tui-search-key {
		height: 100%;
		margin-left: 12rpx;
		display: flex;
		align-items: center;
		border-radius: 15px;
	}

	.tui-input-class {
		width: 380rpx;
    /* #ifdef MP-ALIPAY */
		width: 320rpx;
		/* #endif */
		/* #ifdef H5 || APP-PLUS */
		width: 530rpx;
		/* #endif */
	}

	.tui-key-text {
		box-sizing: border-box;
		padding-right: 12rpx;
		font-size: 12px;
		line-height: 12px;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	/*screen*/

	.tui-header-screen {
		width: 100%;
		box-sizing: border-box;
		background: #fff;
		position: fixed;
		z-index: 1000;
	}

	.tui-screen-top,
	.tui-screen-bottom {
		display: flex;
		align-items: center;
		justify-content: space-between;
		font-size: 28rpx;
		color: #333;
	}

	.tui-screen-top {
		height: 88rpx;
		position: relative;
		background: #fff;
	}

	.tui-top-item {
		height: 28rpx;
		line-height: 28rpx;
		flex: 1;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.tui-topitem-active {
		color: #e41f19;
	}

	.tui-screen-bottom {
		height: 100rpx;
		padding: 0 30rpx;
		box-sizing: border-box;
		font-size: 24rpx;
		align-items: center;
		overflow: hidden;
	}

	.tui-bottom-text {
		line-height: 26rpx;
		max-width: 82%;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.tui-bottom-item {
		flex: 1;
		width: 0;
		display: flex;
		align-items: center;
		justify-content: center;
		padding: 0 12rpx;
		box-sizing: border-box;
		background-color: #f7f7f7;
		margin-right: 20rpx;
		white-space: nowrap;
		height: 60rpx;
		border-radius: 40rpx;
	}

	.tui-bottom-item:last-child {
		margin-right: 0;
	}

	.tui-btmItem-active {
		background-color: #fcedea !important;
		color: #e41f19;
		font-weight: bold;
		position: relative;
	}

	.tui-btmItem-active::after {
		content: '';
		position: absolute;
		border: 1rpx solid #e41f19;
		width: 100%;
		height: 100%;
		border-radius: 40rpx;
		left: 0;
		top: 0;
	}

	.tui-btmItem-tap {
		position: relative;
		border-bottom-left-radius: 0;
		border-bottom-right-radius: 0;
	}

	.tui-btmItem-tap::after {
		content: '';
		position: absolute;
		width: 100%;
		height: 22rpx;
		background: #f7f7f7;
		left: 0;
		top: 58rpx;
	}

	.tui-bold {
		font-weight: bold;
	}

	.tui-active {
		color: #e41f19;
	}

	.tui-addr-left {
		padding-left: 6rpx;
	}

	.tui-seizeaseat-20 {
		height: 20rpx;
	}

	.tui-seizeaseat-30 {
		height: 30rpx;
	}

	/*screen*/

	/*顶部下拉选择 属性*/

	.tui-scroll-box {
		width: 100%;
		height: 480rpx;
		box-sizing: border-box;
		position: relative;
		z-index: 99;
		color: #fff;
		font-size: 30rpx;
		word-break: break-all;
	}

	.tui-drop-item {
		color: #333;
		height: 80rpx;
		font-size: 28rpx;
		padding: 20rpx 40rpx 20rpx 40rpx;
		box-sizing: border-box;
		display: inline-block;
		width: 50%;
	}

	.tui-drop-btnbox {
		width: 100%;
		height: 100rpx;
		position: absolute;
		left: 0;
		bottom: 0;
		box-sizing: border-box;
		display: flex;
	}

	.tui-drop-btn {
		width: 50%;
		font-size: 32rpx;
		text-align: center;
		height: 100rpx;
		line-height: 100rpx;
		border: 0;
	}

	.tui-btn-red {
		background: #e41f19;
		color: #fff;
	}

	.tui-red-hover {
		background: #c51a15 !important;
		color: #e5e5e5;
	}

	.tui-btn-white {
		background: #fff;
		color: #333;
	}

	.tui-white-hover {
		background: #e5e5e5;
		color: #2e2e2e;
	}

	/*顶部下拉选择 属性*/

	/*顶部下拉选择 综合*/

	.tui-dropdownlist {
		width: 100%;
		position: absolute;
		background-color: #fff;
		border-bottom-left-radius: 24rpx;
		border-bottom-right-radius: 24rpx;
		overflow: hidden;
		box-sizing: border-box;
		padding-top: 10rpx;
		padding-bottom: 26rpx;
		left: 0;
		top: 88rpx;
		visibility: hidden;
		transition: all 0.2s ease-in-out;
		z-index: 999;
	}

	.tui-dropdownlist-show {
		visibility: visible;
	}

	.tui-dropdownlist-mask {
		position: fixed;
		top: 0;
		left: 0;
		right: 0;
		bottom: 0;
		background-color: rgba(0, 0, 0, 0.6);
		z-index: -1;
		transition: all 0.2s ease-in-out;
		opacity: 0;
		visibility: hidden;
	}

	.tui-mask-show {
		opacity: 1;
		visibility: visible;
	}

	.tui-dropdownlist-item {
		color: #333;
		height: 70rpx;
		font-size: 28rpx;
		padding: 0 40rpx;
		box-sizing: border-box;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	/*顶部下拉选择 综合*/

	.tui-drawer-box {
		width: 686rpx;
		font-size: 24rpx;
		overflow: hidden;
		position: relative;
		padding-bottom: 100rpx;
	}

	.tui-drawer-title {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 0 30rpx;
		box-sizing: border-box;
		height: 80rpx;
	}

	.tui-title-bold {
		font-size: 26rpx;
		font-weight: bold;
		flex-shrink: 0;
	}

	.tui-location {
		margin-right: 6rpx;
	}

	.tui-attr-right {
		width: 70%;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		text-align: right;
	}

	.tui-all-box {
		width: 90%;
		white-space: nowrap;
		display: flex;
		align-items: center;
		justify-content: flex-end;
	}

	.tui-drawer-content {
		padding: 16rpx 30rpx 30rpx 30rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
		box-sizing: border-box;
	}

	.tui-input {
		border: 0;
		height: 64rpx;
		border-radius: 32rpx;
		width: 45%;
		background-color: #f7f7f7;
		text-align: center;
		font-size: 24rpx;
		color: #333;
	}

	.tui-phcolor {
		text-align: center;
		color: #b2b2b2;
		font-size: 24rpx;
	}

	.tui-flex-attr {
		flex-wrap: wrap;
		justify-content: flex-start;
	}

	.tui-attr-item {
		width: 30%;
		height: 64rpx;
		background-color: #f7f7f7;
		display: flex;
		align-items: center;
		justify-content: center;
		padding: 0 4rpx;
		box-sizing: border-box;
		border-radius: 32rpx;
		margin-right: 5%;
		margin-bottom: 5%;
	}

	.tui-attr-ellipsis {
		white-space: nowrap;
		text-overflow: ellipsis;
		overflow: hidden;
		width: 96%;
		text-align: center;
	}

	.tui-attr-item:nth-of-type(3n) {
		margin-right: 0%;
	}

	.tui-attr-btnbox {
		width: 100%;
		position: absolute;
		left: 0;
		bottom: 0;
		box-sizing: border-box;
		padding: 0 30rpx;
		background: #fff;
	}

	.tui-attr-safearea {
		height: 100rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding-bottom: env(safe-area-inset-bottom);
	}

	.tui-safearea-bottom {
		width: 100%;
		height: env(safe-area-inset-bottom);
	}

	.tui-attr-btnbox::before {
		content: '';
		position: absolute;
		top: 0;
		right: 0;
		left: 0;
		border-top: 1px solid #eaeef1;
		transform: scaleY(0.5) translateZ(0);
		transform-origin: 0 0;
	}

	.tui-drawer-btn {
		width: 47%;
		text-align: center;
		height: 60rpx;
		border-radius: 30rpx;
		flex-shrink: 0;
		display: flex;
		align-items: center;
		justify-content: center;
		box-sizing: border-box;
	}

	.tui-drawerbtn-black {
		border: 1rpx solid #555;
	}

	.tui-drawerbtn-primary {
		background: #e41f19;
		color: #fff;
	}

	/* 商品列表*/
	.tui-product-list {
		display: flex;
		justify-content: space-between;
		flex-direction: row;
		flex-wrap: wrap;
		box-sizing: border-box;
	}

	.tui-product-container {
		flex: 1;
		margin-right: 10rpx;
	}

	.tui-product-container:last-child {
		margin-right: 0;
	}

	.tui-pro-item {
		width: 100%;
		margin-bottom: 10rpx;
		background: #fff;
		box-sizing: border-box;
    box-shadow: 0 3rpx 20rpx rgba(183, 183, 183, 0.3);
    border-radius: 20rpx;
		overflow: hidden;
		transition: all 0.15s ease-in-out;
	}

	.tui-flex-list {
		display: flex;
		margin-bottom: 1rpx !important;
	}

	.tui-pro-img {
		width: 100%;
		display: block;
	}

	.tui-new-label {
		width: 56rpx;
		height: 56rpx;
		border-top-left-radius: 12rpx;
		position: absolute;
	}

	.tui-proimg-list {
		width: 260rpx;
		height: 260rpx !important;
		flex-shrink: 0;
		border-radius: 12rpx;
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

	/* 商品列表*/


	.tui-history-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 30rpx 0;
	}

	.tui-history-content {
		display: flex;
		align-items: center;
		flex-wrap: wrap;
	}

	.tui-icon-delete {
		padding: 10rpx;
	}

	.tui-search-title {
		font-size: 28rpx;
		font-weight: bold;
	}

	.tui-hot-header {
		padding: 30rpx 0;
	}

  .shut-icon {
    margin-top: 5rpx;
    position: absolute;
  }
</style>

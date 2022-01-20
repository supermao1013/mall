<template>
	<view class="container">
		<view class="no-cart" v-if="cartGoods.length <= 0 && cartGoodsDisabled.length <= 0">
			<view class="c">
				<view class="title-box">
					购物车空空如也～
				</view>
				<view class="to-index-btn" @tap="toIndexPage">
					去逛逛
				</view>
			</view>
		</view>
		<view v-else>
			<!-- #ifdef MP || H5-->
			<view class="tui-edit-goods" v-if="cartGoods.length > 0">
				<view>购物车已选<text class="tui-goods-num">{{cartTotal.checkedGoodsCount}}</text>件商品</view>
				<view>
					<tui-button type="gray" :plain="true" shape="circle" width="160rpx" height="60rpx" :size="24"
						@click="editGoods">{{isEdit?"完成":"编辑商品"}}</tui-button>
				</view>
			</view>
			<!-- #endif -->

			<checkbox-group>
				<view class="tui-cart-cell  tui-mtop" v-for="(cart,index) in cartGoods" :key="index">
					<tui-list-cell :hover="false" :arrow="true" @click="switchShops(cart.shopsSn)">
						<view class="tui-goods-title">
							<tui-icon name="shop" :size="22"></tui-icon><text
								class="shops-name">{{cart.name||''}}</text>
						</view>
					</tui-list-cell>
					<view class="tui-goods-item" v-for="(item, i) in cart.cartList" :key="i">
						<label class="tui-checkbox" @tap="checkedItem(index, i)">
							<checkbox :value="item.id" :checked="item.checked === 1" color="yellow"></checkbox>
						</label>
						<image :src="item.listPicUrl" class="tui-goods-img" :data-id="item.goodsId"
							@tap="navToGoodsDetail" />
						<view class="tui-goods-info">
							<view class="tui-goods-title">
								{{item.goodsName}}
							</view>
              <view class="tui-goods-model" @click="updateSkuShow(item)">
								<view class="tui-model-text">{{item.goodsSpecifitionNameValue||''}}</view>
                <tui-icon name="arrowdown" :size="16" color="#333"></tui-icon>
							</view>
							<view class="tui-price-box">
								<view class="tui-goods-price">￥{{item.retailPrice | getPrice}}</view>
								<tui-numberbox :height="36" :width="64" :min="item.minSell||1" :step="1" :index="index"
									:custom="item" :value="item.number" @change="changeNum">
								</tui-numberbox>
							</view>
						</view>
					</view>
				</view>
			</checkbox-group>

			<!--商品失效-->
			<view class="tui-cart-cell  tui-mtop" v-if="cartGoodsDisabled.length>0">
				<view class="tui-activity">
					<view class="tui-bold">失效商品</view>
					<view class="tui-buy">
						<tui-button type="gray" :plain="true" shape="circle" width="200rpx" height="56rpx" :size="24"
							@click="clearDisable">
							清空失效商品</tui-button>
					</view>
				</view>
				<view :class="{'tui-invalid-ptop':index!==0}" v-for="(item,index) in cartGoodsDisabled" :key="index">
					<tui-swipe-action :actions="actions" @click="deleteCartByItem({'item':item})" :params="item">
						<template v-slot:content>
							<view class="tui-goods-item">
								<view class="tui-checkbox tui-invalid-pr">
									<view class="tui-invalid-text">失效</view>
								</view>
								<image :src="item.listPicUrl" class="tui-goods-img" />
								<view class="tui-goods-info">
									<view class="tui-goods-title tui-gray">
										{{item.goodsName}}
									</view>
									<view class="tui-price-box tui-flex-center">
										<view class="tui-goods-invalid">产品失效</view>
									</view>
								</view>
							</view>
						</template>
					</tui-swipe-action>
				</view>
			</view>
		</view>
		<view v-if="footprintList.length >0">
			<!--猜你喜欢-->
			<tui-divider :size="28" :bold="true" color="#333" width="50%">
				<tui-icon name="like" :size="18" color="#e41f19"></tui-icon>
				<text class="tui-youlike">猜你喜欢</text>
			</tui-divider>
			<view class="tui-product-list">
				<view class="tui-product-container">
					<block v-for="(item,index) in footprintList" :key="index" v-if="(index+1)%2!=0">
						<!--商品列表-->
						<view class="tui-pro-item" hover-class="hover" :hover-start-time="150" :data-id="item.goodsId"
							@tap="navToGoodsDetail">
							<image :src="item.listPicUrl" class="tui-pro-img" mode="widthFix" />
							<view class="tui-pro-content">
								<view class="tui-pro-tit">{{item.goodsName}}</view>
								<view>
									<view class="tui-pro-price">
										<text class="tui-sale-price">￥{{item.retailPrice}}</text>
										<text class="tui-factory-price">￥{{item.marketPrice}}</text>
									</view>
									<view class="tui-pro-pay">{{item.sales||0}}人付款</view>
								</view>
							</view>
						</view>
						<!--商品列表-->
						<!-- <template is="productItem" data="{{item,index:index}}" /> -->
					</block>
				</view>
				<view class="tui-product-container">
					<block v-for="(item,index) in footprintList" :key="index" v-if="(index+1)%2==0">
						<!--商品列表-->
						<view class="tui-pro-item" hover-class="hover" :hover-start-time="150" :data-id="item.goodsId"
							@tap="navToGoodsDetail">
							<image :src="item.listPicUrl" class="tui-pro-img" mode="widthFix" />
							<view class="tui-pro-content">
								<view class="tui-pro-tit">{{item.goodsName}}</view>
								<view>
									<view class="tui-pro-price">
										<text class="tui-sale-price">￥{{item.retailPrice}}</text>
										<text class="tui-factory-price">￥{{item.marketPrice}}</text>
									</view>
									<view class="tui-pro-pay">{{item.sales||0}}人付款</view>
								</view>
							</view>
						</view>
					</block>
				</view>
			</view>
		</view>
		<!--tabbar-->
		<view class="tui-tabbar" v-if="cartGoods.length > 0">
			<view class="tui-checkAll">
				<checkbox-group @change="checkedAll">
					<label class="tui-checkbox">
						<checkbox :checked="checkedAllStatus ? true : false" color="yellow"></checkbox>
						<text class="tui-checkbox-pl">全选</text>
					</label>
				</checkbox-group>
				<view class="tui-total-price" v-if="!isEdit">合计:<text
						class="tui-bold">￥{{cartTotal.checkedGoodsAmount | getPrice}}</text>
				</view>
			</view>
			<view>
				<tui-button width="200rpx" height="70rpx" :size="30" type="danger" shape="circle" v-if="!isEdit"
					@click="checkoutOrder">去结算({{cartTotal.checkedGoodsCount}})</tui-button>
				<tui-button width="200rpx" height="70rpx" :size="30" type="danger" shape="circle" :plain="true"
					@click="deleteCart" v-else>删除</tui-button>
			</view>
		</view>

    <!--底部选择层-->
    <tui-bottom-popup :show="openAttr" tui-popup-class="tui-popup" @close="switchAttrPop">
      <view class="tui-popup-box">
        <view class="tui-product-box tui-padding">
          <image :src="selectPic" @click="previewSkuImg(selectPic)" class="tui-popup-img"></image>
          <view class="tui-popup-price">
            <view class="tui-amount tui-bold">￥{{selectPrice}}<text
                class="tui-original-price tui-gray tui-line-through">￥{{selectMarketPrice||''}}</text>
            </view>
            <view class="tui-number">编号:{{selectGoodsSn}} 库存：{{selectStock}}</view>
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
          <tui-button type="danger" shape="circle" :size="25" height="60rpx" class="tui-btn-equals tui-flex"
                      @click="updateSku">确定</tui-button>
        </view>
        <tui-icon name="close-fill" color="#999" class="tui-icon-close" :size="25" @click="switchAttrPop">
        </tui-icon>
      </view>
    </tui-bottom-popup>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
        openAttr: false,
        selected: '',
        selectPrice: '',
        selectMarketPrice: '',
        selectPic: '',
        selectStock: '',
        selectedText: '',
        selectGoodsSn: '',
        goods: {},
        number: 1,
        minNumber: 1,
        commodityAttr: [],
        includeGroup: [],
        keyValue: [],
				cartGoods: [{
					cartList: []
				}],
				cartGoodsDisabled: [],
				checkedAllStatus: false,
        firstIndex: 0,
				cartIds: [], //购物车id
				cartTotal: {
					"goodsCount": 0,
					"goodsAmount": 0.00,
					"checkedGoodsCount": 0,
					"checkedGoodsAmount": 0.00
				},
				actions: [{
					name: '删除',
					color: '#fff',
					fontsize: 28,
					width: 64,
					background: '#F82400'
				}],
				isEdit: false,
				footprintList: []
			}
		},
		filters: {
			getPrice(price) {
				price = price || 0;
				return price.toFixed(2)
			}
		},
		methods: {
      updateSku: function() {
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
            that.openAttr = !that.openAttr;
            return;
          }
          //更新购物车
          util.request('cart/updateSku', {
            skuId: that.includeGroup[0].id,
            goodsId: that.goods.id,
            referrerUserId: that.referrerUserId,
            number: that.number,
            selectedText: that.selectedText,
            shopsId: that.goods.shopsId
          }, "POST").then(function(res) {
            let _res = res;
            if (_res.code == 0) {
              that.getCartList();
              that.openAttr = !that.openAttr;
            } else {
              util.toast(_res.msg);
            }
          });
        }
      },
      updateSkuShow: function(item) {
        var that = this;
        that.goods = {}
        that.minNumber = 1
        that.number = 1
        that.selectPrice = ''
        that.selectMarketPrice = ''
        that.selectPic = ''
        that.selectStock = ''
        that.selectGoodsSn = ''
        that.commodityAttr = []
        that.includeGroup = that.commodityAttr
        that.keyValue = []

        util.request('goods/detail', {
          goodsId: item.goodsId
        }).then(function(res) {
          if (res.code === 0) {
            that.goods = res.data.info
            that.minNumber = that.goods.minSell || 1
            that.number = that.minNumber
            that.selectPrice = res.data.info.retailPrice
            that.selectMarketPrice = res.data.info.marketPrice
            that.selectPic = res.data.info.listPicUrl
            that.selectStock = res.data.info.goodsNumber
            that.selectGoodsSn = res.data.info.goodsSn

            that.commodityAttr = res.data.info.goodsSkuEntityList;
            that.includeGroup = that.commodityAttr;
            that.distachAttrValue(that.commodityAttr);
            if (that.openAttr == false) {
              //打开规格选择窗口
              that.openAttr = !that.openAttr;
            }
          }
        });

      },
      changeNumber: function(event) {
        this.number = event.value;
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
          that.selectGoodsSn = that.goods.goodsSn
          that.selectedText = selectedText
          return;
        }
        that.selectPic = that.includeGroup[0].listPicUrl || that.goods.listPicUrl
        that.selectMarketPrice = that.includeGroup[0].marketPrice
        that.selectPrice = that.includeGroup[0].retailPrice
        that.selectStock = that.includeGroup[0].goodsNumber
        that.selectGoodsSn = that.includeGroup[0].goodsSn
        that.selectedText = selectedText
        that.minNumber = that.includeGroup[0].minSell || 1
        that.number = that.minNumber
      },
      previewSkuImg(url) {
        uni.previewImage({
          urls: [url], // 需要预览的图片http链接列表
        })
      },
      switchAttrPop: function() {
        this.openAttr = !this.openAttr;
      },
			switchShops(shopsSn) {
				uni.navigateTo({
					url: `/pages/shops/shops?shopsSn=${shopsSn}`
				})
			},
			toIndexPage: function() {
				uni.switchTab({
					url: "/pages/index/index"
				});
			},
			getCartList: function() {
				let that = this;
				util.request('cart/myCart').then(function(res) {
					if (res.code === 0) {
						that.cartGoods = res.shopsCartList
						that.cartGoodsDisabled = res.disabled
						that.cartTotal = res.cartTotal

            that.checkedAllStatus = that.isCheckedAll()

            that.getFootprintList();
					}
				});
			},
			isCheckedAll: function() {
				//判断购物车商品已全选
				let result = true;
				for (let i = 0; i < this.cartGoods.length; i++) {
					let element = this.cartGoods[i]
					for (let j = 0; j < element.cartList.length; j++) {
						if (element.cartList[j].checked === 0) {
							result = false;
						}
					}
				}
				return result;
			},
			getFootprintList() {
				let that = this;
				util.request('user/footprintList').then(function(res) {
					if (res.code === 0) {
						if (res.data.records) {
							that.footprintList = res.data.records
						}
					}
				});
			},
			changeNum: function(event) {
				let that = this;
				let cartItem = event.custom;
				let number = event.value;
				cartItem.number = number;
				that.cartGoods = that.cartGoods;
				that.updateCart(cartItem.goodsId, number, cartItem.id);
			},
			updateCart: function(goodsId, number, id) {
				let that = this;

				util.request('cart/update', {
					goodsId: goodsId,
					number: number,
					id: id
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						that.cartGoods = res.shopsCartList
						that.cartGoodsDisabled = res.disabled
						that.cartTotal = res.cartTotal
					}
					that.checkedAllStatus = that.isCheckedAll()
				});

			},
			clearDisable: function() {
				//获取已选择的商品
				let cartIds = [];
				this.cartGoodsDisabled.forEach((item) => {
					cartIds.push(item.id)
				})
				this.cartDelete(cartIds.join(','))
			},
			deleteCartByItem: function(event) {
				//获取已选择的商品
				let cartIds = [event.item.id];
				this.cartDelete(cartIds.join(','))
			},
			editGoods: function() {
				this.isEdit = !this.isEdit;
			},
			navToGoodsDetail: function(e) {
				uni.navigateTo({
					url: '/pages/goods/goods?id=' + e.currentTarget.dataset.id
				});
			},
			checkedAll() {
				let that = this;
				let cartIds = [];
				for (let i = 0; i < this.cartGoods.length; i++) {
					let element = this.cartGoods[i]
					for (let j = 0; j < element.cartList.length; j++) {
						cartIds.push(element.cartList[j].id)
					}
				}
				util.request('cart/checked', {
					cartIds: cartIds,
					isChecked: that.isCheckedAll() ? 0 : 1
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						that.cartGoods = res.shopsCartList
						that.cartGoodsDisabled = res.disabled
						that.cartTotal = res.cartTotal
					}
					that.checkedAllStatus = that.isCheckedAll()
				});
			},
			deleteCart: function() {
				//获取已选择的商品
				let that = this;

				let cartSelectGoods = [];
				for (let i = 0; i < this.cartGoods.length; i++) {
					let element = this.cartGoods[i]
					for (let j = 0; j < element.cartList.length; j++) {
						if (element.cartList[j].checked == true) {
							cartSelectGoods.push(element.cartList[j].id)
						}
					}
				}
				if (cartSelectGoods.length <= 0) {
					return false;
				}
				that.cartDelete(cartSelectGoods.join(','))
			},
			cartDelete(cartIds) {
				let that = this;
				util.request('cart/delete', {
					cartIds: cartIds,
					shopsId: that.shopsId
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						that.cartGoods = res.shopsCartList
						that.cartGoodsDisabled = res.disabled
						that.cartTotal = res.cartTotal
					}
					that.checkedAllStatus = that.isCheckedAll()
				});
			},
			checkedItem: function(index, itemIndex) {
				let that = this;

				util.request('cart/checked', {
					id: that.cartGoods[index].cartList[itemIndex].id,
					isChecked: that.cartGoods[index].cartList[itemIndex].checked ? 0 : 1
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						that.cartGoods = res.shopsCartList
						that.cartGoodsDisabled = res.disabled
						that.cartTotal = res.cartTotal
					}
					that.checkedAllStatus = that.isCheckedAll()
				});
			},
			checkoutOrder: function() {
				//获取已选择的商品
				let that = this;

				var checkedGoods = that.cartGoods.filter(function(element, index, array) {
					for (let i = 0; i < element.cartList.length; i++) {
						if (element.cartList[i].checked == true) {
							return true;
						} else {
							return false;
						}
					}
				});

				if (checkedGoods.length <= 0) {
					util.toast('您还没有选择商品哦', 2000, 'none');
					return false;
				}

				uni.navigateTo({
					url: '../shopping/checkout/checkout'
				})
			}
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			var that = this;
			this.getCartList();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		onLoad: function(options) {
			uni.setStorageSync("navUrl", "/pages/cart/cart");
		},
		onShow: function() {
			this.isEdit = false;
			// 页面显示
			this.getCartList();
		},
		onNavigationBarButtonTap(e) {
			this.isEdit = !this.isEdit;
			let text = this.isEdit ? "完成" : "编辑";
			// #ifdef APP-PLUS
			let webView = this.$mp.page.$getAppWebview();
			webView.setTitleNViewButtonStyle(0, {
				text: text
			});
			// #endif
		}
	}
</script>

<style>
	.container {
		padding-bottom: 120rpx;
	}

	.no-cart {
		width: 100%;
		height: auto;
		margin: 0 auto;
	}

	.no-cart .c {
		width: 100%;
		height: auto;
		margin-bottom: 150rpx;
	}

	.no-cart .c image {
		margin: 0 auto;
		display: block;
		text-align: center;
		width: 258rpx;
		height: 258rpx;
	}

	.no-cart .c text {
		margin: 0 auto;
		display: block;
		width: 258rpx;
		height: 29rpx;
		line-height: 29rpx;
		text-align: center;
		font-size: 29rpx;
		color: #999;
	}

	.title-box {
		width: 100%;
		padding-top: 200rpx;
		text-align: center;
		font-size: 28rpx;
		color: #999;
		background: url(data:image/png;base64,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) no-repeat center 105rpx;
		background-size: 100rpx auto;
		margin-bottom: 50rpx;
	}

	.to-index-btn {
		color: #fff;
		background: #e41f19;
		border-radius: 6px;
		width: 300rpx;
		height: auto;
		line-height: 70rpx;
		text-align: center;
		font-size: 28rpx;
		margin: 0 auto;
		display: block;
	}

	.tui-mtop {
		margin-top: 24rpx;
	}

	.tui-edit-goods {
		width: 100%;
		border-radius: 12rpx;
		overflow: hidden;
		padding: 24rpx 30rpx 0 30rpx;
		box-sizing: border-box;
		display: flex;
		justify-content: space-between;
		align-items: center;
		color: #333;
		font-size: 24rpx;
	}

	.tui-goods-num {
		font-weight: bold;
		color: #e41f19;
	}

	.tui-cart-cell {
		width: 100%;
		border-radius: 12rpx;
		background: #FFFFFF;
		padding: 10rpx 0;
		overflow: hidden;
	}

	.tui-goods-item {
		display: flex;
		padding: 0 30rpx;
		box-sizing: border-box;
	}

	.tui-checkbox {
		min-width: 70rpx;
		display: flex;
		align-items: center;
	}

	/* #ifdef MP-WEIXIN */
	.tui-checkbox .wx-checkbox-input {
		width: 40rpx;
		height: 40rpx;
		margin-right: 0 !important;
		border-radius: 50% !important;
		transform: scale(0.8);
		border-color: #d1d1d1 !important;
	}

	.tui-checkbox .wx-checkbox-input.wx-checkbox-input-checked {
		background: #eb0909;
		width: 44rpx !important;
		height: 44rpx !important;
		border: none;
	}

	/* #endif */
	/* #ifndef MP-WEIXIN */

	>>>.tui-checkbox .uni-checkbox-input {
		width: 40rpx;
		height: 40rpx;
		margin-right: 0 !important;
		border-radius: 50% !important;
		transform: scale(0.8);
		border-color: #d1d1d1 !important;
	}

	>>>.tui-checkbox .uni-checkbox-input.uni-checkbox-input-checked {
		background: #eb0909;
		width: 45rpx !important;
		height: 45rpx !important;
		border: none;
	}

	/* #endif */
	.tui-goods-img {
		width: 200rpx;
		height: 200rpx !important;
		border-radius: 12rpx;
		flex-shrink: 0;
		display: block;
	}

	.tui-goods-info {
		width: 100%;
		padding-left: 20rpx;
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		justify-content: space-between;
		box-sizing: border-box;
		overflow: hidden;
	}

	.tui-goods-title {
		white-space: normal;
		word-break: break-all;
		overflow: hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
		font-size: 24rpx;
		color: #333;
	}

	.shops-name {
		padding: 0 10rpx;
		font-size: 30rpx;
		font-weight: bold;
	}

	.tui-goods-model {
		max-width: 100%;
		color: #333;
		background: #F5F5F5;
		border-radius: 40rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 0 16rpx;
		box-sizing: border-box;
	}

	.tui-model-text {
		max-width: 100%;
		transform: scale(0.9);
		transform-origin: 0 center;
		font-size: 24rpx;
		line-height: 32rpx;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.tui-price-box {
		width: 100%;
		display: flex;
		align-items: flex-end;
		justify-content: space-between;
	}

	.tui-goods-price {
		font-size: 34rpx;
		font-weight: 500;
		color: #e41f19;
	}

	.tui-scale {
		transform: scale(0.8);
		transform-origin: 100% 100%;
	}

	.tui-activity {
		font-size: 24rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 0 30rpx 20rpx 100rpx;
		box-sizing: border-box;
	}

	.tui-buy {
		display: flex;
		align-items: center
	}

	.tui-bold {
		font-weight: bold;
	}

	.tui-sub-info {
		max-width: 532rpx;
		font-size: 24rpx;
		line-height: 24rpx;
		padding: 20rpx 30rpx 10rpx 30rpx;
		box-sizing: border-box;
		color: #333;
		transform: scale(0.8);
		transform-origin: 100% center;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		margin-left: auto
	}

	.tui-invalid-text {
		width: 66rpx;
		margin-right: 4rpx;
		text-align: center;
		font-size: 24rpx;
		color: #fff;
		background: rgba(0, 0, 0, .3);
		transform: scale(0.8);
		transform-origin: center center;
		border-radius: 4rpx;
		flex-shrink: 0;
	}

	.tui-gray {
		color: #B2B2B2 !important;
	}

	.tui-goods-invalid {
		color: #555;
		font-size: 24rpx;
	}

	.tui-flex-center {
		align-items: center !important;
	}

	.tui-invalid-ptop {
		padding-top: 40rpx;
	}

	.tui-tabbar {
		width: 100%;
		height: 100rpx;
		background: #fff;
		position: fixed;
		left: 0;
		bottom: 0;
		/* #ifdef H5 */
		bottom: 50px;
		/* #endif */
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 0 30rpx;
		box-sizing: border-box;
		font-size: 24rpx;
		z-index: 99;
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

	.tui-checkAll {
		display: flex;
		align-items: center;
	}

	.tui-checkbox-pl {
		padding-left: 12rpx;
	}

	.tui-total-price {
		padding-left: 30rpx;
		font-size: 30rpx !important;
	}

	/*猜你喜欢*/
	.tui-youlike {
		padding-left: 12rpx
	}

	.tui-product-list {
		display: flex;
		justify-content: space-between;
		flex-direction: row;
		flex-wrap: wrap;
		box-sizing: border-box;
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
    margin: 5rpx 5rpx;
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
    /* #ifdef H5 */
    bottom: 50px;
    /* #endif */
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
</style>

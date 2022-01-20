// #ifdef H5
const jweixin = require('@/libs/jweixin-1.4.1.js');
// #endif
const utils = {
	projectName: '微同商城旗舰版',
	// 域名
	domain: 'https://fly2you.cn/',
	// domain: 'http://localhost:8899/',
	// domain: 'http://192.168.1.3:8889/',

	//微信公众号appId
	mpAppId: '',

	//使用的小程序的原始ID
	maAppId: 'gh_',

	// todo 申请 https://lbs.qq.com/qqmap_wx_jssdk/index.html，详细接入配置请查看产品文档
	qqMapKey: '',

	// todo 快递鸟注册 http://www.kdniao.com/reg
	kdnBusinessId: '',
	kdnAppKey: '',

	//接口地址
	interfaceUrl: function() {
		return utils.domain + 'platform-api/app/'
	},
	toast: function(text, duration, success) {
		uni.showToast({
			title: text || "出错啦~",
			// #ifndef MP-ALIPAY
			// 支付宝小程序不支持
			duration: duration || 2000,
			// #endif
			icon: success || 'none'
		})
	},
	modal: function(title, content, showCancel = false, callback, confirmColor, confirmText, cancelColor,
		cancelText) {
		uni.showModal({
			title: title || '提示',
			content: content,
			showCancel: showCancel,
			// #ifndef MP-ALIPAY
			// 支付宝小程序不支持
			cancelColor: cancelColor || "#555",
			confirmColor: confirmColor || "#e41f19",
			// #endif
			confirmText: confirmText || "确定",
			cancelText: cancelText || "取消",
			success(res) {
				if (res.confirm) {
					callback && callback(true)
				} else {
					callback && callback(false)
				}
			}
		})
	},
	isWeChat: function() {
		//window.navigator.userAgent属性包含了浏览器类型、版本、操作系统类型、浏览器引擎类型等信息，这个属性可以用来判断浏览器类型
		var ua = window.navigator.userAgent.toLowerCase();
		//通过正则表达式匹配ua中是否含有MicroMessenger字符串
		if (ua.match(/MicroMessenger/i) == 'micromessenger') {
			return true;
		} else {
			return false;
		}
	},
	// #ifdef H5
	isPc() {
		if ((navigator.userAgent.match(
				/(iPhone|iPod|Android|ios|iOS|iPad|Backerry|WebOS|Symbian|Windows Phone|Phone)/i))) {
			return false;
		} else {
			return true;
		}
	},
	initJssdk: function(link) {
		utils.request('auth/createJsapiSignature/' + utils.mpAppId, {
			url: link
		}).then(function(res) {
			if (res.code === 0) {
				let jsapiSignature = res.data;
				jweixin.config({
					debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
					appId: jsapiSignature.appId, // 必填，公众号的唯一标识
					timestamp: jsapiSignature.timestamp, // 必填，生成签名的时间戳
					nonceStr: jsapiSignature.nonceStr, // 必填，生成签名的随机串
					signature: jsapiSignature.signature, // 必填，签名
					jsApiList: [
						'checkJsApi',
						'chooseWXPay',
						'onMenuShareTimeline',
						'onMenuShareAppMessage',
						'getLocation'
					] // 必填，需要使用的JS接口列表
				});
			}
		});
	},
	// #endif
	existWx: function() {
		if (plus.runtime.isApplicationExist({
				pname: 'com.tencent.mm',
				action: 'weixin://'
			})) {
			//安装了微信
			return true
		} else {
			//未安装微信
			return false
		}
	},
	isAndroid: function() {
		const res = uni.getSystemInfoSync();
		return res.platform.toLocaleLowerCase() == "android"
	},
	isIphone: function() {
		const res = uni.getSystemInfoSync();
		return res.platform.toLocaleLowerCase() == "ios";
	},
	isIphone13: function() {
		const res = uni.getSystemInfoSync();
		return (res.platform.toLocaleLowerCase() == "ios" && res.system >= 13)
	},
	isIphoneX: function() {
		const res = uni.getSystemInfoSync();
		let iphonex = false;
		let models = ['iphonex', 'iphonexr', 'iphonexsmax', 'iphone11', 'iphone11pro', 'iphone11promax']
		const model = res.model.replace(/\s/g, "").toLowerCase()
		if (models.includes(model)) {
			iphonex = true;
		}
		return iphonex;
	},
	constNum: function() {
		let time = 0;
		// #ifdef APP-PLUS
		time = this.isAndroid() ? 300 : 0;
		// #endif
		return time
	},
	delayed: null,
	/**
	 * 请求数据处理
	 * @param string url 请求地址
	 * @param {*} postData 请求参数
	 * @param string method 请求方式
	 *  GET or POST
	 * @param string contentType 数据格式
	 *  'application/x-www-form-urlencoded'
	 *  'application/json'
	 * @param bool isDelay 是否延迟显示loading
	 * @param bool hideLoading 是否隐藏loading
	 *  true: 隐藏
	 *  false:显示
	 */
	request: function(url, postData = {}, method = "GET", contentType = "application/json", isDelay, hideLoading) {
		//接口请求
		let loadding = false;
		utils.delayed && uni.hideLoading();
		clearTimeout(utils.delayed);
		utils.delayed = null;
		if (!hideLoading) {
			utils.delayed = setTimeout(() => {
				uni.showLoading({
					// #ifndef MP-TOUTIAO || MP-ALIPAY
					// 头条、支付宝不支持
					mask: true,
					// #endif
					title: '请稍候...',
					success(res) {
						loadding = true
					}
				})
			}, isDelay ? 1000 : 0)
		}

		return new Promise((resolve, reject) => {
			// #ifdef MP-WEIXIN
			let info = uni.getAccountInfoSync()
			// #endif
			uni.request({
				url: utils.interfaceUrl() + url,
				data: postData,
				header: {
					'content-type': contentType,
					// #ifdef MP-WEIXIN
					'maAppId': info.miniProgram.appId || '',
					// #endif
					'token': utils.getToken()
				},
				method: method, //'GET','POST'
				dataType: 'json',
				success: (res) => {
					if (loadding && !hideLoading) {
						uni.hideLoading()
					}
					if (res.statusCode === 200) {
						if (res.data.code === 401) {
							//返回码401说明token过期或者用户未登录
							uni.removeStorage({
								key: 'token',
								success() {
									//个人中心页不跳转
									if (uni.getStorageSync("navUrl") !=
										"/pages/ucenter/index/index") {
										utils.modal('温馨提示', '您还没有登录，是否去登录', true, (
											confirm) => {
											if (confirm) {
												uni.redirectTo({
													url: '/pages/auth/btnAuth/btnAuth',
												})
											} else {
												uni.navigateBack({
													delta: 1,
													fail: (res) => {
														uni.switchTab({
															url: '/pages/index/index',
														})
													}
												})
											}
										})
									}
								}
							})
						} else if (res.data.code === 500) {
							utils.toast(res.data.msg)
						} else if (res.data.code === 404) {
							utils.toast(res.data.msg)
						}
						resolve(res.data);
					} else {
						reject(res.data.msg);
					}
				},
				fail: (res) => {
					utils.toast("网络不给力，请稍后再试~")
					reject(res)
				},
				complete: function(res) {
					clearTimeout(utils.delayed)
					utils.delayed = null;
					if (res.statusCode === 200) {
						if (res.data.code === 0 || res.data.code === 401) {
							uni.hideLoading()
						} else {
							utils.toast(res.data.msg)
						}
					} else {
						utils.toast('服务器开小差了~')
					}
				}
			})
		})
	},
	/**
	 * 上传文件
	 * @param string url 请求地址
	 * @param string src 文件路径
	 */
	uploadFile: function(url, src) {
		uni.showLoading({
			title: '请稍候...'
		})
		return new Promise((resolve, reject) => {
			const uploadTask = uni.uploadFile({
				url: utils.interfaceUrl() + url,
				filePath: src,
				name: 'file',
				header: {
					// #ifndef H5
					'content-type': 'multipart/form-data',
					// #endif
					'token': utils.getToken()
				},
				success: function(res) {
					uni.hideLoading()
					let data = JSON.parse(res.data.replace(/\ufeff/g, "") || "{}")
					if (data.code == 0) {
						//返回图片地址
						resolve(data)
					} else {
						utils.toast(res.msg);
					}
				},
				fail: function(res) {
					utils.toast("网络不给力，请稍后再试~")
					reject(res)
				}
			})
		})
	},
	tuiJsonp: function(url, callback, callbackname) {
		// #ifdef H5
		window[callbackname] = callback;
		let tuiScript = document.createElement("script");
		tuiScript.src = url;
		tuiScript.type = "text/javascript";
		document.head.appendChild(tuiScript);
		document.head.removeChild(tuiScript);
		// #endif
	},
	//设置用户信息
	setUserInfo: function(mobile, token) {
		uni.setStorageSync("token", token)
		uni.setStorageSync("mobile", mobile)
	},
	//获取token
	getToken: function() {
		return uni.getStorageSync("token")
	},
	//判断是否登录
	isLogin: function() {
		return uni.getStorageSync("mobile") ? true : false
	},
	//跳转页面，校验登录状态
	href: function(url, isVerify) {
		if (isVerify && !utils.isLogin()) {
			uni.navigateTo({
				url: '/pages/common/login/login'
			})
		} else {
			uni.navigateTo({
				url: url
			});
		}
	},
	//去空格
	trim: function(value) {
		return value.replace(/(^\s*)|(\s*$)/g, "");
	},
	//内容替换
	replaceAll: function(text, repstr, newstr) {
		return text.replace(new RegExp(repstr, "gm"), newstr);
	},
	//格式化手机号码
	formatNumber: function(num) {
		return num.length === 11 ? num.replace(/^(\d{3})\d{4}(\d{4})$/, '$1****$2') : num;
	},
	//金额格式化
	rmoney: function(money) {
		return parseFloat(money).toFixed(2).toString().split('').reverse().join('').replace(/(\d{3})/g, '$1,')
			.replace(
				/\,$/, '').split('').reverse().join('');
	},
	// 时间格式化输出，如11:03 25:19 每1s都会调用一次
	dateformat: function(micro_second) {
		// 总秒数
		var second = Math.floor(micro_second / 1000);
		// 天数
		var day = Math.floor(second / 3600 / 24);
		// 小时
		var hr = Math.floor(second / 3600 % 24);
		// 分钟
		var min = Math.floor(second / 60 % 60);
		// 秒
		var sec = Math.floor(second % 60);
		return {
			day,
			hr: hr < 10 ? '0' + hr : hr,
			min: min < 10 ? '0' + min : min,
			sec: sec < 10 ? '0' + sec : sec,
			second: second
		}
	},
	//日期格式化
	formatDate: function(formatStr, fdate) {
		if (fdate) {
			if (~fdate.indexOf('.')) {
				fdate = fdate.substring(0, fdate.indexOf('.'));
			}
			fdate = fdate.toString().replace('T', ' ').replace(/\-/g, '/');
			var fTime, fStr = 'ymdhis';
			if (!formatStr)
				formatStr = "y-m-d h:i:s";
			if (fdate)
				fTime = new Date(fdate);
			else
				fTime = new Date();
			var month = fTime.getMonth() + 1;
			var day = fTime.getDate();
			var hours = fTime.getHours();
			var minu = fTime.getMinutes();
			var second = fTime.getSeconds();
			month = month < 10 ? '0' + month : month;
			day = day < 10 ? '0' + day : day;
			hours = hours < 10 ? ('0' + hours) : hours;
			minu = minu < 10 ? '0' + minu : minu;
			second = second < 10 ? '0' + second : second;
			var formatArr = [
				fTime.getFullYear().toString(),
				month.toString(),
				day.toString(),
				hours.toString(),
				minu.toString(),
				second.toString()
			]
			for (var i = 0; i < formatArr.length; i++) {
				formatStr = formatStr.replace(fStr.charAt(i), formatArr[i]);
			}
			return formatStr;
		} else {
			return "";
		}
	},
	getDistance: function(lat1, lng1, lat2, lng2) {
		function Rad(d) {
			return d * Math.PI / 180.0;
		}
		if (!lat1 || !lng1) {
			return '';
		}
		// lat1用户的纬度
		// lng1用户的经度
		// lat2商家的纬度
		// lng2商家的经度
		let radLat1 = Rad(lat1);
		let radLat2 = Rad(lat2);
		let a = radLat1 - radLat2;
		let b = Rad(lng1) - Rad(lng2);
		let s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2) + Math.cos(radLat1) * Math.cos(radLat2) *
			Math.pow(
				Math.sin(b / 2), 2)));
		s = s * 6378.137;
		s = Math.round(s * 10000) / 10000;
		s = s.toFixed(2) //保留两位小数
		return s
	},
	isMobile: function(mobile) {
		if (!mobile) {
			utils.toast('请输入手机号码');
			return false
		}
		if (!mobile.match(/^1[3-9][0-9]\d{8}$/)) {
			utils.toast('手机号不正确');
			return false
		}
		return true
	},
	rgbToHex: function(r, g, b) {
		return "#" + utils.toHex(r) + utils.toHex(g) + utils.toHex(b)
	},
	toHex: function(n) {
		n = parseInt(n, 10);
		if (isNaN(n)) return "00";
		n = Math.max(0, Math.min(n, 255));
		return "0123456789ABCDEF".charAt((n - n % 16) / 16) +
			"0123456789ABCDEF".charAt(n % 16);
	},
	hexToRgb(hex) {
		let result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
		return result ? {
			r: parseInt(result[1], 16),
			g: parseInt(result[2], 16),
			b: parseInt(result[3], 16)
		} : null;
	},
	transDate: function(date, fmt) {
		if (!date) {
			return '--'
		}
		let _this = new Date(date * 1000)
		let o = {
			'M+': _this.getMonth() + 1,
			'd+': _this.getDate(),
			'h+': _this.getHours(),
			'm+': _this.getMinutes(),
			's+': _this.getSeconds(),
			'q+': Math.floor((_this.getMonth() + 3) / 3),
			'S': _this.getMilliseconds()
		}
		if (/(y+)/.test(fmt)) {
			fmt = fmt.replace(RegExp.$1, (_this.getFullYear() + '').substr(4 - RegExp.$1.length))
		}
		for (let k in o) {
			if (new RegExp('(' + k + ')').test(fmt)) {
				fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (('00' + o[k]).substr(('' + o[
					k]).length)))
			}
		}
		return fmt
	},
	isNumber: function(val) {
		let regPos = /^\d+(\.\d+)?$/; //非负浮点数
		let regNeg =
			/^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$/; //负浮点数
		if (regPos.test(val) || regNeg.test(val)) {
			return true;
		} else {
			return false;
		}
	},
	//判断字符串是否为空
	isEmpty: function(str) {
		if (str === '' || str === undefined || str === null) {
			return true;
		} else {
			return false;
		}
	},
	expireTime: function(str) {
		if (!str) {
			return;
		}
		let NowTime = new Date().getTime();
		//IOS系统直接使用new Date('2018-10-29 11:25:21')，在IOS上获取不到对应的时间对象。
		let totalSecond = Date.parse(str.replace(/-/g, '/')) - NowTime || [];
		if (totalSecond < 0) {
			return;
		}
		return totalSecond / 1000
	},

	/**
	 * 统一下单请求
	 */
	payOrder: function(orderId) {
		let tradeType = 'JSAPI'
		// #ifdef APP-PLUS
		tradeType = 'APP'
		// #endif
		// #ifdef H5
		tradeType = 'MWEB'
		if (utils.isWeChat()) {
			tradeType = 'JSAPI'
		}
		// #endif
		return new Promise(function(resolve, reject) {
			utils.request('pay/prepay', {
				orderId: orderId,
				tradeType: tradeType,
				mpAppId: utils.mpAppId
			}, 'POST').then((res) => {
				if (res.code === 0) {
					// #ifdef APP-PLUS
					let appOrderResult = res.appOrderResult;
					uni.requestPayment({
						provider: 'wxpay',
						orderInfo: {
							"appid": appOrderResult.appId,
							"noncestr": appOrderResult.nonceStr,
							"package": appOrderResult.packageValue,
							"partnerid": appOrderResult.partnerId,
							"prepayid": appOrderResult.prepayId,
							"timestamp": appOrderResult.timeStamp,
							"sign": appOrderResult.sign
						},
						success: function(res) {
							console.log(res)
							resolve(res);
						},
						fail: function(res) {
							console.log(res)
							reject(res);
						},
						complete: function(res) {
							console.log(res)
							reject(res);
						}
					});
					// #endif

					// #ifdef MP-WEIXIN
					let payParam = res.data;
					uni.requestPayment({
						'timeStamp': payParam.timeStamp,
						'nonceStr': payParam.nonceStr,
						'package': payParam.packageValue,
						'signType': payParam.signType,
						'paySign': payParam.paySign,
						'success': function(res) {
							console.log(res)
							resolve(res);
						},
						'fail': function(res) {
							console.log(res)
							reject(res);
						},
						'complete': function(res) {
							console.log(res)
							reject(res);
						}
					});
					// #endif

					// #ifdef H5
					if (utils.isWeChat()) {
						let payParam = res.data;
						utils.initJssdk(location.href)
						jweixin.ready(function() {
							jweixin.chooseWXPay({
								timestamp: payParam
									.timeStamp, // 支付签名时间戳，注意微信jssdk中的所有使用timestamp字段均为小写。但最新版的支付后台生成签名使用的timeStamp字段名需大写其中的S字符
								nonceStr: payParam.nonceStr, // 支付签名随机串，不长于 32 位
								package: payParam
									.packageValue, // 统一支付接口返回的prepay_id参数值，提交格式如：prepay_id=\*\*\*）
								signType: payParam
									.signType, // 签名方式，默认为'SHA1'，使用新版支付需传入'MD5'
								paySign: payParam.paySign, // 支付签名
								success: function(res) {
									resolve(res);
								}
							});
						})
					} else {
						location.href = res.mwebOrderResult.mwebUrl + '&redirect_url=' +
							encodeURIComponent(utils.domain +
								'h5/#/pages/payResult/payResult?orderId=' + orderId)
					}
					// #endif

				} else {
					reject(res);
				}
			});
		});
	},

	/**
	 * 当面付
	 */
	faceToface: function(money, shopsId) {
		let tradeType = 'JSAPI'
		// #ifdef APP-PLUS
		tradeType = 'APP'
		// #endif
		// #ifdef H5
		tradeType = 'MWEB'
		if (utils.isWeChat()) {
			tradeType = 'JSAPI'
		}
		// #endif
		return new Promise(function(resolve, reject) {
			utils.request('pay/faceToface', {
				fromType: utils.getFromType(),
				shopsId: shopsId,
				money: money,
				tradeType: tradeType
			}, 'POST').then((res) => {
				if (res.code === 0) {
					// #ifdef APP-PLUS
					let appOrderResult = res.appOrderResult;
					uni.requestPayment({
						provider: 'wxpay',
						orderInfo: {
							"appid": appOrderResult.appId,
							"noncestr": appOrderResult.nonceStr,
							"package": appOrderResult.packageValue,
							"partnerid": appOrderResult.partnerId,
							"prepayid": appOrderResult.prepayId,
							"timestamp": appOrderResult.timeStamp,
							"sign": appOrderResult.sign
						},
						success: function(res) {
							console.log(res)
							resolve(res);
						},
						fail: function(res) {
							console.log(res)
							reject(res);
						},
						complete: function(res) {
							console.log(res)
							reject(res);
						}
					});
					// #endif

					// #ifdef MP-WEIXIN
					let payParam = res.data;
					uni.requestPayment({
						'timeStamp': payParam.timeStamp,
						'nonceStr': payParam.nonceStr,
						'package': payParam.packageValue,
						'signType': payParam.signType,
						'paySign': payParam.paySign,
						'success': function(res) {
							console.log(res)
							resolve(res);
						},
						'fail': function(res) {
							console.log(res)
							reject(res);
						},
						'complete': function(res) {
							console.log(res)
							reject(res);
						}
					});
					// #endif

					// #ifdef H5
					if (utils.isWeChat()) {
						let payParam = res.data;
						utils.initJssdk(location.href)
						jweixin.ready(function() {
							jweixin.chooseWXPay({
								timestamp: payParam
									.timeStamp, // 支付签名时间戳，注意微信jssdk中的所有使用timestamp字段均为小写。但最新版的支付后台生成签名使用的timeStamp字段名需大写其中的S字符
								nonceStr: payParam.nonceStr, // 支付签名随机串，不长于 32 位
								package: payParam
									.packageValue, // 统一支付接口返回的prepay_id参数值，提交格式如：prepay_id=\*\*\*）
								signType: payParam
									.signType, // 签名方式，默认为'SHA1'，使用新版支付需传入'MD5'
								paySign: payParam.paySign, // 支付签名
								success: function(res) {
									resolve(res);
								}
							});
						})
					} else {
						location.href = res.mwebOrderResult.mwebUrl + '&redirect_url=' +
							encodeURIComponent(utils.domain +
								'h5/#/pages/ucenter/index/index')
					}
					// #endif

				} else {
					reject(res);
				}
			});
		});
	},
	/**
	 * 统一下单请求
	 */
	payOrderAli: function(orderId) {
		return new Promise(function(resolve, reject) {
			// #ifdef APP-PLUS
			utils.request('pay/aliPrepay', {
				orderId: orderId
			}, 'POST').then((res) => {
				if (res.code === 0) {
					let orderInfo = res.data
					uni.requestPayment({
						provider: 'alipay',
						orderInfo: orderInfo,
						success: function(res) {
							console.log(res)
							resolve(res);
						},
						fail: function(res) {
							console.log(res)
							reject(res);
						},
						complete: function(res) {
							console.log(res)
							reject(res);
						}
					});
				} else {
					reject(res);
				}
			});
			// #endif
			// #ifdef MP-ALIPAY
			utils.request('pay/aliPrepayMa', {
				orderId: orderId
			}, 'POST').then((res) => {
				if (res.code === 0) {
					let orderInfo = res.data
					uni.requestPayment({
						provider: 'alipay',
						orderInfo: orderInfo,
						success: function(res) {
							console.log(res)
							resolve(res);
						},
						fail: function(res) {
							console.log(res)
							reject(res);
						},
						complete: function(res) {
							console.log(res)
							reject(res);
						}
					});
				} else {
					reject(res);
				}
			});
			// #endif

			// #ifdef H5
			if (utils.isWeChat()) {
				uni.showModal({
					title: '温馨提示',
					content: '微信环境不支持使用支付宝支付，请在菜单中选择在默认浏览器中打开，以完成支付',
					showCancel: false,
					success: function(res) {
						if (res.confirm) {
							uni.navigateTo({
								url: '/pages/ucenter/orderDetail/orderDetail?id=' +
									orderId
							})
						}
					}
				});
			} else {
				// 默认手机环境
				let url = 'pay/aliPrepayWap';
				if (utils.isPc()) {
					// pc访问
					url = 'pay/aliPrepayH5';
				}
				location.href = utils.interfaceUrl() + url + '?orderId=' + orderId + '&returnUrl=' +
					encodeURIComponent(utils.domain + 'h5/#/pages/payResult/payResult?orderId=' +
						orderId) + '&token=' + utils.getToken()
			}
			// #endif
		});
	},
	getFromType: function() {
		let fromType = 1
		// #ifdef APP-PLUS
		fromType = 3
		// #endif
		// #ifdef H5
		fromType = 4
		if (utils.isWeChat()) {
			fromType = 2
		}
		// #endif
		// #ifdef MP-ALIPAY
		fromType = 5
		// #endif
		// #ifdef MP-QQ
		fromType = 6
		// #endif
		// #ifdef MP-WEIXIN
		fromType = 1
		// #endif
		return fromType;
	},
	isMoney: function(money) {
		let re = new RegExp(/((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/);
		if (re.test(money)) {
			return true;
		} else {
			return false;
		}
	}
}

module.exports = {
	projectName: utils.projectName,
	domain: utils.domain,
	mpAppId: utils.mpAppId,
	maAppId: utils.maAppId,
	qqMapKey: utils.qqMapKey,
	kdnBusinessId: utils.kdnBusinessId,
	kdnAppKey: utils.kdnAppKey,
	interfaceUrl: utils.interfaceUrl,
	toast: utils.toast,
	modal: utils.modal,
	isWeChat: utils.isWeChat,
	existWx: utils.existWx,
	isAndroid: utils.isAndroid,
	isIphone: utils.isIphone,
	isIphone13: utils.isIphone13,
	isIphoneX: utils.isIphoneX,
	constNum: utils.constNum,
	request: utils.request,
	uploadFile: utils.uploadFile,
	tuiJsonp: utils.tuiJsonp,
	setUserInfo: utils.setUserInfo,
	getToken: utils.getToken,
	isLogin: utils.isLogin,
	href: utils.href,
	trim: utils.trim,
	replaceAll: utils.replaceAll,
	formatNumber: utils.formatNumber,
	rmoney: utils.rmoney,
	dateformat: utils.dateformat,
	formatDate: utils.formatDate,
	getDistance: utils.getDistance,
	isMobile: utils.isMobile,
	rgbToHex: utils.rgbToHex,
	hexToRgb: utils.hexToRgb,
	transDate: utils.transDate,
	isNumber: utils.isNumber,
	isEmpty: utils.isEmpty,
	expireTime: utils.expireTime,
	payOrder: utils.payOrder,
	payOrderAli: utils.payOrderAli,
	faceToface: utils.faceToface,
	getFromType: utils.getFromType,
	isMoney: utils.isMoney
}
